use anyhow::{Result, anyhow, bail};
use black_board_back::logger::RoomLogger;
use black_board_back::proto::{
    self, BroadcastedAudioChunk, BroadcastedCanvasCommand, CanvasSnapshot, ClientToServer,
    CreateRoomResponse, ErrorResponse, HostEndedSession, InitialResponse, JoinRoomResponse,
    ListRecordingsResponse, RoomEvent, RoomMessage, ServerToClient, UserJoined, UserLeft,
    canvas_command, client_to_server::Payload as ClientPayload, initial_request::RequestType,
    initial_response::ResponseType, room_event::EventType,
    room_message::Payload as RoomMessagePayload, server_to_client::Payload as ServerPayload,
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
                        if !e.to_string().contains("Connection reset by peer") {
                            error!("Connection handling failed for {}: {}", remote_addr, e);
                        }
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
                let mut new_room = Room::new(room_id.clone(), client_id);
                let mut log_receiver = new_room.broadcast_sender.subscribe();

                let participant = new_room.add_participant(client_id, req.username.clone());

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
                            participant_id: participant.participant_id,
                        })),
                    })),
                };
                send_stream.write_all(&response.encode_to_vec()).await?;
                send_stream.finish()?;

                return handle_participant_session(connection, state, room_id, participant).await;
            }
            Some(RequestType::JoinRoom(req)) => {
                let client_id = Uuid::new_v4();
                let (participant, canvas_snapshot) = {
                    let mut state_guard = state.lock().await;
                    let room = match state_guard.rooms.get_mut(&req.room_id) {
                        Some(r) => r,
                        None => {
                            warn!("Room '{}' not found.", req.room_id);
                            let response = ServerToClient {
                                payload: Some(ServerPayload::InitialResponse(InitialResponse {
                                    response_type: Some(ResponseType::ErrorResponse(
                                        ErrorResponse {
                                            message: format!(
                                                "Room with ID '{}' not found.",
                                                req.room_id
                                            ),
                                        },
                                    )),
                                })),
                            };
                            send_stream.write_all(&response.encode_to_vec()).await?;
                            return Err(anyhow!("Room not found"));
                        }
                    };
                    let participant = room.add_participant(client_id, req.username.clone());
                    let snapshot = CanvasSnapshot {
                        paths: room.canvas_history.clone(),
                    };
                    (participant, snapshot)
                };

                let response = ServerToClient {
                    payload: Some(ServerPayload::InitialResponse(InitialResponse {
                        response_type: Some(ResponseType::JoinRoomResponse(JoinRoomResponse {
                            message: format!("Successfully joined room {}", req.room_id),
                            participant_id: participant.participant_id,
                            initial_canvas_state: Some(canvas_snapshot),
                        })),
                    })),
                };
                send_stream.write_all(&response.encode_to_vec()).await?;
                send_stream.finish()?;

                return handle_participant_session(connection, state, req.room_id, participant)
                    .await;
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
                    for entry in entries.flatten() {
                        if let Some(filename) = entry.file_name().to_str() {
                            if filename.ends_with(".binlog") {
                                filenames.push(filename.to_string());
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
                send_stream.finish()?;
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
        let len = match reader.read_u32().await {
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
        send_stream
            .write_all(&message_to_send.encode_to_vec())
            .await?;
        send_stream.finish()?;
    }

    info!("Sending end-of-replay signal to client.");
    let end_event = RoomEvent {
        event_type: Some(EventType::HostEndedSession(HostEndedSession {
            message: "Replay finished.".to_string(),
        })),
    };
    let end_message = ServerToClient {
        payload: Some(ServerPayload::RoomEvent(end_event)),
    };
    let mut final_stream = connection.open_uni().await?;
    final_stream.write_all(&end_message.encode_to_vec()).await?;
    final_stream.finish()?;

    let reason = connection.closed().await;
    info!(
        "Connection for replay closed by peer with reason: {:?}",
        reason
    );

    Ok(())
}

async fn handle_participant_session(
    connection: Connection,
    state: SharedServerState,
    room_id: String,
    participant: Participant,
) -> Result<()> {
    let broadcast_sender = {
        let state_guard = state.lock().await;
        let room = state_guard
            .rooms
            .get(&room_id)
            .ok_or_else(|| anyhow!("Room disappeared while getting sender"))?;
        room.broadcast_sender.clone()
    };

    let join_event = RoomEvent {
        event_type: Some(EventType::UserJoined(UserJoined {
            participant_id: participant.participant_id,
            username: participant.username.clone(),
            client_id_uuid: participant.client_id.to_string(),
        })),
    };
    let _ = broadcast_sender.send(join_event);

    let mut broadcast_receiver = broadcast_sender.subscribe();

    let writer_connection = connection.clone();
    let participant_id_clone = participant.participant_id;
    let client_id_clone = participant.client_id;
    let writer_task = tokio::spawn(async move {
        loop {
            match broadcast_receiver.recv().await {
                Ok(event) => {
                    let should_skip = match &event.event_type {
                        Some(EventType::CanvasCommand(cmd)) => {
                            cmd.from_participant_id == participant_id_clone
                        }
                        Some(EventType::AudioChunk(chunk)) => {
                            chunk.from_participant_id == participant_id_clone
                        }
                        Some(EventType::UserJoined(user)) => {
                            user.participant_id == participant_id_clone
                        }
                        _ => false,
                    };

                    if should_skip {
                        continue;
                    }

                    let message = ServerToClient {
                        payload: Some(ServerPayload::RoomEvent(event)),
                    };

                    match writer_connection.open_uni().await {
                        Ok(mut send_stream) => {
                            if let Err(e) = send_stream.write_all(&message.encode_to_vec()).await {
                                error!(
                                    "Failed to send message to client {}: {}",
                                    client_id_clone, e
                                );
                                break;
                            }
                            let _ = send_stream.finish();
                        }
                        Err(e) => {
                            error!(
                                "Failed to open unidirectional stream for client {}: {}",
                                client_id_clone, e
                            );
                            break;
                        }
                    }
                }
                Err(broadcast::error::RecvError::Lagged(_)) => {
                    warn!("Client {} is lagging behind.", client_id_clone);
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
                let current_participant_id = participant.participant_id;
                tokio::spawn(async move {
                    if let Err(e) = process_client_stream(
                        &mut recv,
                        &sender,
                        current_participant_id,
                        state_clone,
                        &room_id_clone,
                    )
                    .await
                    {
                        warn!(
                            "Failed to process stream from client {}: {}",
                            current_participant_id, e
                        );
                    }
                });
            }
            Err(e) => {
                info!("Client {} disconnected: {}", participant.client_id, e);
                break;
            }
        }
    }

    writer_task.abort();
    info!("Cleaning up resources for client {}", participant.client_id);

    {
        let mut state_guard = state.lock().await;
        if let Some(room) = state_guard.rooms.get_mut(&room_id) {
            if participant.client_id == room.host_id {
                info!(
                    "Host {} has left room {}. Ending session for all.",
                    participant.client_id, room_id
                );
                let end_event = RoomEvent {
                    event_type: Some(EventType::HostEndedSession(HostEndedSession {
                        message: "The host has ended the session.".to_string(),
                    })),
                };
                let _ = room.broadcast_sender.send(end_event);
                state_guard.rooms.remove(&room_id);
            } else {
                room.participants.remove(&participant.client_id);
                info!(
                    "Removed client {} from room {}",
                    participant.client_id, room_id
                );
                let leave_event = RoomEvent {
                    event_type: Some(EventType::UserLeft(UserLeft {
                        participant_id: participant.participant_id,
                        username: participant.username,
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
    participant_id: u32,
    state: SharedServerState,
    room_id: &str,
) -> Result<()> {
    let data = recv_stream.read_to_end(65536).await?;
    let message = ClientToServer::decode(&data[..])?;

    if let Some(ClientPayload::RoomMessage(RoomMessage {
        payload: Some(payload),
    })) = message.payload
    {
        let event_to_broadcast = match &payload {
            RoomMessagePayload::CanvasCommand(cmd) => Some(RoomEvent {
                event_type: Some(EventType::CanvasCommand(BroadcastedCanvasCommand {
                    from_participant_id: participant_id,
                    command: Some(cmd.clone()),
                })),
            }),
            RoomMessagePayload::AudioChunk(chunk) => Some(RoomEvent {
                event_type: Some(EventType::AudioChunk(BroadcastedAudioChunk {
                    from_participant_id: participant_id,
                    chunk: Some(chunk.clone()),
                })),
            }),
        };

        if let Some(event) = event_to_broadcast {
            broadcast_sender.send(event)?;
        }

        if let RoomMessagePayload::CanvasCommand(cmd) = payload {
            use canvas_command::CommandType;
            let mut state_guard = state.lock().await;
            if let Some(room) = state_guard.rooms.get_mut(room_id) {
                match cmd.command_type {
                    Some(CommandType::PathStart(start)) => {
                        let path_data = proto::PathFull {
                            path_id: start.path_id,
                            points: start.point.map_or(vec![], |p| vec![p]),
                            color: start.color,
                            stroke_width: start.stroke_width,
                        };
                        room.active_paths.insert(start.path_id, path_data);
                    }
                    Some(CommandType::PathAppend(append)) => {
                        if let Some(active_path) = room.active_paths.get_mut(&append.path_id) {
                            if let Some(p) = append.point {
                                active_path.points.push(p);
                            }
                        }
                    }
                    Some(CommandType::PathEnd(end)) => {
                        if let Some(finished_path) = room.active_paths.remove(&end.path_id) {
                            info!(
                                "Storing a full path with {} points in history for room {}",
                                finished_path.points.len(),
                                room_id
                            );
                            room.canvas_history.push(finished_path);
                        }
                    }
                    _ => {}
                }
            }
        }
    }
    Ok(())
}

fn configure_server() -> Result<(ServerConfig, Vec<u8>)> {
    let cert = rcgen::generate_simple_self_signed(vec!["localhost".into()])?;
    let cert_der_bytes = cert.cert.der().to_vec();
    let priv_key_der_bytes = cert.signing_key.serialize_der();
    let priv_key = PrivateKeyDer::Pkcs8(priv_key_der_bytes.into());
    let cert_chain = vec![CertificateDer::from(cert_der_bytes.clone())];

    let mut transport = TransportConfig::default();
    transport.max_idle_timeout(Some(std::time::Duration::from_secs(3600 * 24).try_into()?));

    let mut server_config = ServerConfig::with_single_cert(cert_chain, priv_key)?;
    server_config.transport = Arc::new(transport);

    Ok((server_config, cert_der_bytes))
}
