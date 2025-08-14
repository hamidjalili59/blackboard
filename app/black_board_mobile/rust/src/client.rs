use crate::bridge_models::EventMessage;
use crate::frb_generated::StreamSink;
use crate::proto::{
    client_to_server::Payload as ClientPayload,
    initial_request::RequestType,
    initial_response::ResponseType,
    ListRecordingsRequest,
    room_message::Payload as RoomMessagePayload,
    server_to_client::Payload as ServerPayload,
    ClientToServer, CreateRoomRequest, InitialRequest, JoinRoomRequest, ReplayRoomRequest,
    RoomMessage, ServerToClient,
};
use anyhow::{anyhow, bail, Result};
use prost::Message;
use quinn::{crypto::rustls::QuicClientConfig, ClientConfig, Connection, Endpoint};
use rustls::pki_types::{CertificateDer, ServerName};
use rustls::SignatureScheme;
use std::sync::Arc;
use tokio::sync::Mutex;
use tracing::{error, info, warn};

pub struct ClientState {
    connection: Option<Connection>,
    endpoint: Endpoint,
}

impl ClientState {
    pub fn new() -> Result<Self> {
        let client_addr = "0.0.0.0:0".parse().unwrap();
        let mut endpoint = Endpoint::client(client_addr)?;
        endpoint.set_default_client_config(configure_client()?);
        Ok(Self {
            connection: None,
            endpoint,
        })
    }

    // *** متد جدید برای ارسال درخواست لیست و دریافت پاسخ ***
    pub async fn list_recordings(&mut self, server_addr: String) -> Result<Vec<String>> {
        let server_socket_addr = server_addr.parse()?;
        let conn = self
            .endpoint
            .connect(server_socket_addr, "localhost")?
            .await?;
        info!("Connected to server to list recordings at {}", server_addr);

        let (mut send, mut recv) = conn.open_bi().await?;

        let request = ClientToServer {
            payload: Some(ClientPayload::InitialRequest(InitialRequest {
                request_type: Some(RequestType::ListRecordings(ListRecordingsRequest {})),
            })),
        };
        send.write_all(&request.encode_to_vec()).await?;

        // *** رفع خطا: استریم ارسال را به درستی به پایان می‌رسانیم ***
        send.finish()?;

        // منتظر می‌مانیم و تمام پاسخ سرور را می‌خوانیم
        let response_bytes = recv.read_to_end(1024 * 10).await?;

        // *** رفع خطا: دیگر اتصال را به صورت دستی نمی‌بندیم ***
        // conn.close(0u32.into(), b"done");
        // اجازه می‌دهیم اتصال با خارج شدن از اسکوپ به صورت طبیعی مدیریت شود.

        let response = ServerToClient::decode(&response_bytes[..])?;

        if let Some(ServerPayload::InitialResponse(initial_response)) = response.payload {
            if let Some(ResponseType::ListRecordingsResponse(list_response)) =
                initial_response.response_type
            {
                Ok(list_response.filenames)
            } else {
                bail!("Server sent an unexpected response type for list recordings request.")
            }
        } else {
            bail!("Server sent an invalid response for list recordings.")
        }
    }

    // ... (بقیه متدهای شما بدون تغییر باقی می‌مانند) ...

    pub async fn create_room(&mut self, server_addr: String, username: String) -> Result<String> {
        let server_socket_addr = server_addr.parse()?;
        let conn = self
            .endpoint
            .connect(server_socket_addr, "localhost")?
            .await?;
        info!("Connected to server at {}", server_addr);

        let (mut send, mut recv) = conn.open_bi().await?;

        let request = ClientToServer {
            payload: Some(ClientPayload::InitialRequest(InitialRequest {
                request_type: Some(RequestType::CreateRoom(CreateRoomRequest { username })),
            })),
        };
        send.write_all(&request.encode_to_vec()).await?;
        send.finish()?;

        let response_bytes = recv.read_to_end(1024).await?;
        let response = ServerToClient::decode(&response_bytes[..])?;

        if let Some(ServerPayload::InitialResponse(initial_response)) = response.payload {
            if let Some(ResponseType::CreateRoomResponse(create_response)) =
                initial_response.response_type
            {
                let room_id = create_response.room_id;
                info!("Successfully created room with ID: {}", room_id);
                self.connection = Some(conn);
                Ok(room_id)
            } else {
                bail!("Server sent an unexpected response type after create room request.")
            }
        } else {
            bail!("Server sent an invalid initial response.")
        }
    }

    pub async fn join_room(&mut self, server_addr: String, username: String, room_id: String) -> Result<()> {
        let server_socket_addr = server_addr.parse()?;
        let conn = self
            .endpoint
            .connect(server_socket_addr, "localhost")?
            .await?;
        info!("Connected to server at {}", server_addr);

        let (mut send, mut recv) = conn.open_bi().await?;

        let request = ClientToServer {
            payload: Some(ClientPayload::InitialRequest(InitialRequest {
                request_type: Some(RequestType::JoinRoom(JoinRoomRequest {
                    username,
                    room_id,
                })),
            })),
        };
        send.write_all(&request.encode_to_vec()).await?;
        send.finish()?;

        let response_bytes = recv.read_to_end(1024).await?;
        let response = ServerToClient::decode(&response_bytes[..])?;

        if let Some(ServerPayload::InitialResponse(initial_response)) = response.payload {
            if let Some(ResponseType::JoinRoomResponse(_)) = initial_response.response_type {
                info!("Successfully joined room.");
                self.connection = Some(conn);
                Ok(())
            } else if let Some(ResponseType::ErrorResponse(err)) = initial_response.response_type {
                bail!("Failed to join room: {}", err.message)
            } else {
                bail!("Server sent an unexpected response type after join room request.")
            }
        } else {
            bail!("Server sent an invalid initial response.")
        }
    }

    pub async fn listen_events(&self, events_sink: Arc<Mutex<StreamSink<EventMessage>>>) -> Result<()> {
        if let Some(conn) = &self.connection {
            self.start_event_listener(conn.clone(), events_sink).await;
            Ok(())
        } else {
            Err(anyhow!("Not connected to a room. Cannot listen for events."))
        }
    }

    pub async fn replay_room(
        &mut self,
        server_addr: String,
        log_filename: String,
        events_sink: Arc<Mutex<StreamSink<EventMessage>>>,
    ) -> Result<()> {
        let server_socket_addr = server_addr.parse()?;
        let conn = self
            .endpoint
            .connect(server_socket_addr, "localhost")?
            .await?;
        info!("Connected to server for replay at {}", server_addr);

        let (mut send, _) = conn.open_bi().await?;

        let request = ClientToServer {
            payload: Some(ClientPayload::InitialRequest(InitialRequest {
                request_type: Some(RequestType::ReplayRoom(ReplayRoomRequest {
                    log_filename,
                })),
            })),
        };
        send.write_all(&request.encode_to_vec()).await?;
        send.finish()?;

        self.start_event_listener(conn, events_sink).await;
        Ok(())
    }

    async fn start_event_listener(
        &self,
        connection: Connection,
        events_sink: Arc<Mutex<StreamSink<EventMessage>>>,
    ) {
        tokio::spawn(async move {
            info!("Event listener started.");
            loop {
                match connection.accept_uni().await {
                    Ok(mut stream) => {
                        let sink = events_sink.clone();
                        tokio::spawn(async move {
                            match stream.read_to_end(65536).await {
                                Ok(data) => {
                                    if let Ok(msg) = ServerToClient::decode(&data[..]) {
                                        if let Some(ServerPayload::RoomEvent(event)) = msg.payload {
                                            let event_bytes = event.encode_to_vec();
                                            let message = EventMessage { data: event_bytes };
                                            let mut locked_sink = sink.lock().await;
                                            if locked_sink.add(message).is_err() {
                                                warn!("Failed to send event to Flutter: Sink is closed.");
                                            }
                                        }
                                    }
                                }
                                Err(e) => warn!("Failed to read from uni stream: {}", e),
                            }
                        });
                    }
                    Err(e) => {
                        error!("Connection lost: {}. Event listener stopped.", e);
                        break;
                    }
                }
            }
        });
    }

    pub async fn send_room_message(&self, message_payload: RoomMessagePayload) -> Result<()> {
        if let Some(conn) = &self.connection {
            let (mut send, _) = conn.open_bi().await?;
            let message = ClientToServer {
                payload: Some(ClientPayload::RoomMessage(RoomMessage {
                    payload: Some(message_payload),
                })),
            };
            send.write_all(&message.encode_to_vec()).await?;
            send.finish()?;
            Ok(())
        } else {
            Err(anyhow!("Not connected to a room."))
        }
    }

    pub fn disconnect(&mut self) {
        if let Some(conn) = self.connection.take() {
            conn.close(0u32.into(), b"User disconnected");
            info!("Disconnected from the server.");
        }
    }
}

#[derive(Debug)]
struct SkipServerVerification;

impl rustls::client::danger::ServerCertVerifier for SkipServerVerification {
    fn verify_server_cert(
        &self,
        _end_entity: &CertificateDer<'_>,
        _intermediates: &[CertificateDer<'_>],
        _server_name: &ServerName<'_>,
        _ocsp_response: &[u8],
        _now: rustls::pki_types::UnixTime,
    ) -> Result<rustls::client::danger::ServerCertVerified, rustls::Error> {
        Ok(rustls::client::danger::ServerCertVerified::assertion())
    }
    fn verify_tls12_signature(
        &self,
        _message: &[u8],
        _cert: &CertificateDer<'_>,
        _dss: &rustls::DigitallySignedStruct,
    ) -> Result<rustls::client::danger::HandshakeSignatureValid, rustls::Error> {
        Ok(rustls::client::danger::HandshakeSignatureValid::assertion())
    }
    fn verify_tls13_signature(
        &self,
        _message: &[u8],
        _cert: &CertificateDer<'_>,
        _dss: &rustls::DigitallySignedStruct,
    ) -> Result<rustls::client::danger::HandshakeSignatureValid, rustls::Error> {
        Ok(rustls::client::danger::HandshakeSignatureValid::assertion())
    }
    fn supported_verify_schemes(&self) -> Vec<SignatureScheme> {
        rustls::crypto::ring::default_provider()
            .signature_verification_algorithms
            .supported_schemes()
    }
}

fn configure_client() -> Result<ClientConfig> {
    let crypto = rustls::ClientConfig::builder()
        .dangerous()
        .with_custom_certificate_verifier(Arc::new(SkipServerVerification))
        .with_no_client_auth();

    let quic_crypto = QuicClientConfig::try_from(crypto)?;
    Ok(ClientConfig::new(Arc::new(quic_crypto)))
}
