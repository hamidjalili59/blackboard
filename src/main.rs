use anyhow::{Result, anyhow};
use black_board_back::logger::RoomLogger;
use black_board_back::proto::{
    BroadcastedAudioChunk, BroadcastedCanvasCommand, ClientToServer, CreateRoomResponse,
    ErrorResponse, InitialResponse, JoinRoomResponse, RoomEvent, RoomMessage, ServerToClient,
    UserJoined, UserLeft, client_to_server::Payload as ClientPayload, initial_request::RequestType,
    initial_response::ResponseType, room_event::EventType,
    room_message::Payload as RoomMessagePayload, server_to_client::Payload as ServerPayload,
};
use black_board_back::state::{Participant, Room, ServerState};
use prost::Message;
use quinn::{Connection, Endpoint, RecvStream, ServerConfig};
use rand::Rng;
use rustls_pki_types::{CertificateDer, PrivateKeyDer};
use std::fs::File;
use std::io::Write;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::Arc;
use tokio::sync::{Mutex, broadcast};
use tracing::{Level, error, info, warn};
use uuid::Uuid;

type SharedServerState = Arc<Mutex<ServerState>>;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt().with_max_level(Level::INFO).init();
    info!("Starting QUIC server...");

    let addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 12345);
    let (server_config, cert_der) = configure_server()?;
    info!("Saving server certificate to cert.der");
    let mut cert_file = File::create("cert.der")?;
    cert_file.write_all(&cert_der)?;
    info!("Certificate saved successfully.");

    let server_state = Arc::new(Mutex::new(ServerState::new()));
    let endpoint = Endpoint::server(server_config, addr)?;
    info!("Listening on {}", addr);

    while let Some(conn_attempt) = endpoint.accept().await {
        info!("New connection attempt...");
        let state_clone = server_state.clone();
        tokio::spawn(async move {
            match conn_attempt.await {
                Ok(connection) => {
                    let remote_addr = connection.remote_address();
                    info!("Connection established with: {}", remote_addr);
                    if let Err(e) = handle_connection(connection, state_clone).await {
                        error!("Connection handling failed for {}: {}", remote_addr, e);
                    }
                }
                Err(e) => {
                    error!("Failed to establish connection: {}", e);
                }
            }
        });
    }

    Ok(())
}

async fn handle_connection(connection: Connection, state: SharedServerState) -> Result<()> {
    let remote_addr = connection.remote_address();
    let (mut send_stream, mut recv_stream) = connection.accept_bi().await?;
    info!("Accepted initial stream from {}", remote_addr);

    let data = recv_stream.read_to_end(1024).await?;
    let message = ClientToServer::decode(&data[..])?;

    let (room_id, client_id, username) =
        if let Some(ClientPayload::InitialRequest(initial_request)) = message.payload {
            match initial_request.request_type {
                Some(RequestType::CreateRoom(req)) => {
                    info!("Received CreateRoomRequest from user: {}", req.username);
                    let client_id = Uuid::new_v4();
                    const CHARSET: &[u8] = b"ABCDEFGHIJKLMNPQRSTUVWXYZ123456789";
                    let room_id: String = (0..6)
                        .map(|_| {
                            let idx = rand::rng().random_range(0..CHARSET.len());
                            CHARSET[idx] as char
                        })
                        .collect();

                    let logger = RoomLogger::new(&room_id)?;
                    let new_room = Room::new(room_id.clone());
                    let mut log_receiver = new_room.broadcast_sender.subscribe();

                    // تسک لاگر را در یک ترد مجزا اجرا می‌کنیم
                    let logger_room_id = room_id.clone();
                    tokio::spawn(async move {
                        // *** رفع خطا: این خط اصلاح شد تا به فیلد خصوصی دسترسی پیدا نکند ***
                        info!("Logger task started for room {}", logger_room_id);

                        while let Ok(event) = log_receiver.recv().await {
                            if let Err(e) = logger.log(&event).await {
                                error!("Failed to log event for room {}: {}", logger_room_id, e);
                            }
                        }
                        info!("Logger task finished for room {}", logger_room_id);
                    });

                    {
                        let mut state_guard = state.lock().await;
                        state_guard.rooms.insert(room_id.clone(), new_room);
                        info!("New room '{}' and its logger have been created.", room_id);
                    }

                    let response = ServerToClient {
                        payload: Some(ServerPayload::InitialResponse(InitialResponse {
                            response_type: Some(ResponseType::CreateRoomResponse(
                                CreateRoomResponse {
                                    room_id: room_id.clone(),
                                },
                            )),
                        })),
                    };
                    let mut buf = Vec::new();
                    response.encode(&mut buf)?;
                    send_stream.write_all(&buf).await?;

                    (room_id, client_id, req.username)
                }
                Some(RequestType::JoinRoom(req)) => {
                    info!(
                        "Received JoinRoomRequest for room '{}' from user: '{}'",
                        req.room_id, req.username
                    );
                    let client_id = Uuid::new_v4();
                    let state_guard = state.lock().await;

                    if state_guard.rooms.contains_key(&req.room_id) {
                        let response = ServerToClient {
                            payload: Some(ServerPayload::InitialResponse(InitialResponse {
                                response_type: Some(ResponseType::JoinRoomResponse(
                                    JoinRoomResponse {
                                        message: format!(
                                            "Successfully joined room {}",
                                            req.room_id
                                        ),
                                    },
                                )),
                            })),
                        };
                        let mut buf = Vec::new();
                        response.encode(&mut buf)?;
                        send_stream.write_all(&buf).await?;

                        (req.room_id, client_id, req.username)
                    } else {
                        warn!("Room '{}' not found.", req.room_id);
                        let response = ServerToClient {
                            payload: Some(ServerPayload::InitialResponse(InitialResponse {
                                response_type: Some(ResponseType::ErrorResponse(ErrorResponse {
                                    message: format!("Room with ID '{}' not found.", req.room_id),
                                })),
                            })),
                        };
                        let mut buf = Vec::new();
                        response.encode(&mut buf)?;
                        send_stream.write_all(&buf).await?;
                        return Err(anyhow!("Room not found"));
                    }
                }
                None => return Err(anyhow!("Invalid initial request type")),
            }
        } else {
            return Err(anyhow!("First message was not an InitialRequest"));
        };

    send_stream.finish()?;

    info!(
        "Handshake successful. Starting session for user '{}' ({}) in room '{}'",
        username, client_id, room_id
    );
    handle_participant_session(connection, state, room_id, client_id, username).await
}

async fn handle_participant_session(
    connection: Connection,
    state: SharedServerState,
    room_id: String,
    client_id: Uuid,
    username: String,
) -> Result<()> {
    let participant = Participant {
        client_id,
        username: username.clone(),
    };
    let broadcast_sender = {
        let mut state_guard = state.lock().await;
        let room = state_guard
            .rooms
            .get_mut(&room_id)
            .ok_or_else(|| anyhow!("Room disappeared"))?;
        room.participants.insert(client_id, participant.clone());
        room.broadcast_sender.clone()
    };

    let join_event = RoomEvent {
        event_type: Some(EventType::UserJoined(UserJoined {
            client_id: client_id.to_string(),
            username: username.clone(),
        })),
    };
    let _ = broadcast_sender.send(join_event);

    let mut broadcast_receiver = broadcast_sender.subscribe();

    let writer_connection = connection.clone();
    let writer_task = tokio::spawn(async move {
        loop {
            match broadcast_receiver.recv().await {
                Ok(event) => {
                    match &event.event_type {
                        Some(EventType::CanvasCommand(cmd))
                            if cmd.from_client_id == client_id.to_string() =>
                        {
                            continue;
                        }
                        Some(EventType::AudioChunk(chunk))
                            if chunk.from_client_id == client_id.to_string() =>
                        {
                            continue;
                        }
                        _ => {}
                    }

                    let message = ServerToClient {
                        payload: Some(ServerPayload::RoomEvent(event)),
                    };
                    let mut buf = Vec::new();
                    message.encode(&mut buf).unwrap();

                    match writer_connection.open_uni().await {
                        Ok(mut send_stream) => {
                            if let Err(e) = send_stream.write_all(&buf).await {
                                error!("Failed to send message to client {}: {}", client_id, e);
                                break;
                            }
                        }
                        Err(e) => {
                            error!(
                                "Failed to open unidirectional stream for client {}: {}",
                                client_id, e
                            );
                            break;
                        }
                    }
                }
                Err(broadcast::error::RecvError::Lagged(_)) => {
                    warn!("Client {} is lagging behind.", client_id);
                }
                Err(broadcast::error::RecvError::Closed) => break,
            }
        }
    });

    loop {
        match connection.accept_bi().await {
            Ok((_send, mut recv)) => {
                let sender = broadcast_sender.clone();
                tokio::spawn(async move {
                    if let Err(e) = process_client_stream(&mut recv, &sender, client_id).await {
                        warn!("Failed to process stream from client {}: {}", client_id, e);
                    }
                });
            }
            Err(e) => {
                info!("Client {} disconnected: {}", client_id, e);
                break;
            }
        }
    }

    writer_task.abort();
    info!("Cleaning up resources for client {}", client_id);

    {
        let mut state_guard = state.lock().await;
        if let Some(room) = state_guard.rooms.get_mut(&room_id) {
            room.participants.remove(&client_id);
            info!("Removed client {} from room {}", client_id, room_id);

            if room.participants.is_empty() {
                info!("Room {} is now empty and will be removed.", room_id);
                state_guard.rooms.remove(&room_id);
            } else {
                let leave_event = RoomEvent {
                    event_type: Some(EventType::UserLeft(UserLeft {
                        client_id: client_id.to_string(),
                        username,
                    })),
                };
                let _ = room.broadcast_sender.send(leave_event);
            }
        }
    }

    Ok(())
}

async fn process_client_stream(
    recv_stream: &mut RecvStream,
    broadcast_sender: &broadcast::Sender<RoomEvent>,
    client_id: Uuid,
) -> Result<()> {
    let data = recv_stream.read_to_end(65536).await?;
    let message = ClientToServer::decode(&data[..])?;

    if let Some(ClientPayload::RoomMessage(RoomMessage {
        payload: Some(payload),
    })) = message.payload
    {
        let event = match payload {
            RoomMessagePayload::CanvasCommand(cmd) => {
                info!("Broadcasting CanvasCommand from {}", client_id);
                RoomEvent {
                    event_type: Some(EventType::CanvasCommand(BroadcastedCanvasCommand {
                        from_client_id: client_id.to_string(),
                        command: Some(cmd),
                    })),
                }
            }
            RoomMessagePayload::AudioChunk(chunk) => {
                info!("Broadcasting AudioChunk from {}", client_id);
                RoomEvent {
                    event_type: Some(EventType::AudioChunk(BroadcastedAudioChunk {
                        from_client_id: client_id.to_string(),
                        chunk: Some(chunk),
                    })),
                }
            }
        };
        broadcast_sender.send(event)?;
    }
    Ok(())
}

fn configure_server() -> Result<(ServerConfig, Vec<u8>)> {
    let cert = rcgen::generate_simple_self_signed(vec!["localhost".into()])?;
    let cert_der_bytes = cert.cert.der().to_vec();
    let priv_key_der_bytes = cert.signing_key.serialize_der();
    let cert_chain = vec![CertificateDer::from(cert_der_bytes.clone())];
    let priv_key = PrivateKeyDer::from(rustls_pki_types::PrivatePkcs8KeyDer::from(
        priv_key_der_bytes,
    ));
    let server_config = ServerConfig::with_single_cert(cert_chain, priv_key)?;
    Ok((server_config, cert_der_bytes))
}
