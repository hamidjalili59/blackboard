use anyhow::{anyhow, bail, Result};
use black_board_back::logger::RoomLogger;
use black_board_back::proto::{
    self, client_to_server::Payload as ClientPayload,
    canvas_command,
    initial_request::RequestType,
    initial_response::ResponseType,
    ListRecordingsResponse,
    room_event::EventType,
    room_message::Payload as RoomMessagePayload, server_to_client::Payload as ServerPayload,
    BroadcastedAudioChunk, BroadcastedCanvasCommand, ClientToServer, CreateRoomResponse,
    ErrorResponse, HostEndedSession, InitialResponse, JoinRoomResponse, RoomEvent, RoomMessage,
    ServerToClient, UserJoined, UserLeft,
};
use black_board_back::state::{Participant, Room, ServerState};
use prost::Message;
use quinn::{Connection, Endpoint, RecvStream, ServerConfig, TransportConfig};
use rand::Rng;
use rustls_pki_types::{CertificateDer, PrivateKeyDer};
use std::fs;
use std::fs::File;
use std::io::Write;
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::Arc;
use tokio::fs::File as TokioFile;
use tokio::io::{AsyncReadExt, BufReader};
use tokio::sync::{broadcast, Mutex};
use tracing::{error, info, warn, Level};
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

    if let Some(ClientPayload::InitialRequest(initial_request)) = message.payload {
        match initial_request.request_type {
            Some(RequestType::CreateRoom(req)) => {
                let client_id = Uuid::new_v4();
                const CHARSET: &[u8] = b"ABCDEFGHIJKLMNPQRSTUVWXYZ123456789";
                let room_id: String = (0..6)
                    .map(|_| {
                        let idx = rand::rng().random_range(0..CHARSET.len());
                        CHARSET[idx] as char
                    })
                    .collect();

                let logger = RoomLogger::new(&room_id)?;
                let new_room = Room::new(room_id.clone(), client_id);
                let mut log_receiver: broadcast::Receiver<RoomEvent> = new_room.broadcast_sender.subscribe();

                let logger_room_id = room_id.clone();
                tokio::spawn(async move {
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
                    info!("New room '{}' created by host {}.", room_id, client_id);
                }

                let response = ServerToClient {
                    payload: Some(ServerPayload::InitialResponse(InitialResponse {
                        response_type: Some(ResponseType::CreateRoomResponse(CreateRoomResponse {
                            room_id: room_id.clone(),
                        })),
                    })),
                };
                send_stream.write_all(&response.encode_to_vec()).await?;
                send_stream.finish()?;

                return handle_participant_session(connection, state, room_id, client_id, req.username).await;
            }
            Some(RequestType::JoinRoom(req)) => {
                let client_id = Uuid::new_v4();
                let history_to_send;
                {
                    let mut state_guard = state.lock().await;
                    let room = match state_guard.rooms.get_mut(&req.room_id) {
                        Some(r) => r,
                        None => {
                            warn!("Room '{}' not found.", req.room_id);
                            let response = ServerToClient {
                                payload: Some(ServerPayload::InitialResponse(InitialResponse {
                                    response_type: Some(ResponseType::ErrorResponse(ErrorResponse {
                                        message: format!("Room with ID '{}' not found.", req.room_id),
                                    })),
                                })),
                            };
                            send_stream.write_all(&response.encode_to_vec()).await?;
                            return Err(anyhow!("Room not found"));
                        }
                    };
                    history_to_send = room.canvas_history.clone();
                }

                let response = ServerToClient {
                    payload: Some(ServerPayload::InitialResponse(InitialResponse {
                        response_type: Some(ResponseType::JoinRoomResponse(JoinRoomResponse {
                            message: format!("Successfully joined room {}", req.room_id),
                        })),
                    })),
                };
                send_stream.write_all(&response.encode_to_vec()).await?;
                send_stream.finish()?;

                info!("Sending {} historical canvas paths to new user {}", history_to_send.len(), client_id);
                for cmd in history_to_send {
                    let event = RoomEvent {
                        event_type: Some(EventType::CanvasCommand(BroadcastedCanvasCommand {
                            from_client_id: "history".to_string(),
                            command: Some(cmd),
                        })),
                    };
                    let message = ServerToClient { payload: Some(ServerPayload::RoomEvent(event)) };
                    let mut uni_stream = connection.open_uni().await?;
                    uni_stream.write_all(&message.encode_to_vec()).await?;
                    uni_stream.finish()?;
                }

                return handle_participant_session(connection, state, req.room_id, client_id, req.username).await;
            }
            Some(RequestType::ReplayRoom(req)) => {
                info!("Received ReplayRoomRequest for log: {}", req.log_filename);
                send_stream.finish()?;
                return handle_replay_request(connection, req.log_filename).await;
            }
            Some(RequestType::ListRecordings(_)) => {
                info!("Received ListRecordingsRequest from {}", remote_addr);
                let mut filenames = Vec::new();
                let records_dir = "records";
                
                if let Ok(entries) = fs::read_dir(records_dir) {
                    for entry in entries {
                        if let Ok(entry) = entry {
                            if let Some(filename) = entry.file_name().to_str() {
                                if filename.ends_with(".binlog") {
                                    filenames.push(filename.to_string());
                                }
                            }
                        }
                    }
                }

                let response = ServerToClient {
                    payload: Some(ServerPayload::InitialResponse(InitialResponse {
                        response_type: Some(ResponseType::ListRecordingsResponse(
                            ListRecordingsResponse { filenames },
                        )),
                    })),
                };

                send_stream.write_all(&response.encode_to_vec()).await?;
                
                // *** رفع خطا: به جای بستن کل اتصال، فقط استریم را به درستی به پایان می‌رسانیم ***
                // این کار به کلاینت اجازه می‌دهد تا تمام داده‌ها را دریافت کند.
                send_stream.finish()?;
                
                // منتظر می‌مانیم تا کلاینت نیز سمت خود را ببندد و سپس خارج می‌شویم.
                // خواندن تا انتها، منتظر می‌ماند تا کلاینت استریم ارسال خود را ببندد.
                let _ = recv_stream.read_to_end(0).await;
                
                info!("Finished sending recording list to {}", remote_addr);
                return Ok(());
            }
            None => return Err(anyhow!("Invalid initial request type")),
        }
    } else {
        return Err(anyhow!("First message was not an InitialRequest"));
    }
}

async fn handle_replay_request(connection: Connection, log_filename: String) -> Result<()> {
    let file_path = std::path::Path::new("records").join(&log_filename);
    
    if !file_path.exists() {
        bail!("Log file not found: {}", log_filename);
    }

    let file = TokioFile::open(file_path).await?;
    let mut reader = BufReader::new(file);

    loop {
        let len_result = reader.read_u32().await;
        let len = match len_result {
            Ok(l) => l as usize,
            Err(ref e) if e.kind() == std::io::ErrorKind::UnexpectedEof => {
                info!("Finished streaming log file: {}", log_filename);
                break;
            }
            Err(e) => return Err(e.into()),
        };

        let mut event_buf = vec![0; len];
        reader.read_exact(&mut event_buf).await?;

        let event = proto::RoomEvent::decode(&event_buf[..])?;
        let message_to_send = ServerToClient {
            payload: Some(ServerPayload::RoomEvent(event)),
        };

        let mut send_stream = connection.open_uni().await?;
        send_stream.write_all(&message_to_send.encode_to_vec()).await?;
        send_stream.finish()?;
    }

    connection.close(0u32.into(), b"replay_finished");
    Ok(())
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
                            continue
                        }
                        Some(EventType::AudioChunk(chunk))
                            if chunk.from_client_id == client_id.to_string() =>
                        {
                            continue
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
                let state_clone = state.clone();
                let room_id_clone = room_id.clone();
                tokio::spawn(async move {
                    if let Err(e) = process_client_stream(&mut recv, &sender, client_id, state_clone, &room_id_clone).await {
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
            if client_id == room.host_id {
                info!("Host {} has left room {}. Ending session for all.", client_id, room_id);
                let end_event = RoomEvent {
                    event_type: Some(EventType::HostEndedSession(HostEndedSession {
                        message: "The host has ended the session.".to_string(),
                    })),
                };
                let _ = room.broadcast_sender.send(end_event);
                state_guard.rooms.remove(&room_id);
            } else {
                room.participants.remove(&client_id);
                info!("Removed client {} from room {}", client_id, room_id);
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
    state: SharedServerState,
    room_id: &str,
) -> Result<()> {
    let data = recv_stream.read_to_end(65536).await?;
    let message = ClientToServer::decode(&data[..])?;

    if let Some(ClientPayload::RoomMessage(RoomMessage { payload: Some(payload) })) = message.payload {
        
        if let RoomMessagePayload::CanvasCommand(ref cmd) = payload {
            if let Some(canvas_command::CommandType::PathFull(_)) = &cmd.command_type {
                let mut state_guard = state.lock().await;
                if let Some(room) = state_guard.rooms.get_mut(room_id) {
                    info!("Storing a full path in canvas history for room {}", room_id);
                    room.canvas_history.push(cmd.clone());
                }
            }
        }

        let event = match payload {
            RoomMessagePayload::CanvasCommand(cmd) => RoomEvent {
                event_type: Some(EventType::CanvasCommand(
                    BroadcastedCanvasCommand {
                        from_client_id: client_id.to_string(),
                        command: Some(cmd),
                    },
                )),
            },
            RoomMessagePayload::AudioChunk(chunk) => RoomEvent {
                event_type: Some(EventType::AudioChunk(
                    BroadcastedAudioChunk {
                        from_client_id: client_id.to_string(),
                        chunk: Some(chunk),
                    },
                )),
            },
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
    let priv_key = PrivateKeyDer::from(
        rustls_pki_types::PrivatePkcs8KeyDer::from(priv_key_der_bytes),
    );
    
    let mut transport = TransportConfig::default();
    transport.max_idle_timeout(Some(std::time::Duration::from_secs(3600 * 24).try_into()?));

    let mut server_config = ServerConfig::with_single_cert(cert_chain, priv_key)?;
    server_config.transport = Arc::new(transport);

    Ok((server_config, cert_der_bytes))
}
