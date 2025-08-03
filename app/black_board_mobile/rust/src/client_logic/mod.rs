// // rust/src/client_logic/mod.rs

// use crate::api::ServerEvent;
// use crate::frb_generated::StreamSink;
// use crate::proto::{client_to_server, server_to_client, ClientToServer, ServerToClient};
// use anyhow::{anyhow, Result};
// use lazy_static::lazy_static;
// use log::{error, info};
// use prost::Message;
// use quinn::crypto::rustls::QuicClientConfig;
// use quinn::{ClientConfig, Connection, Endpoint};
// use rustls_pki_types::CertificateDer;
// use std::net::SocketAddr;
// use std::sync::Arc;
// use std::time::Duration;
// use tokio::runtime::Runtime;
// use tokio::sync::Mutex;

// lazy_static! {
//     // یک Runtime سراسری برای اجرای تسک‌های async
//     static ref TOKIO_RUNTIME: Runtime = tokio::runtime::Builder::new_multi_thread()
//         .enable_all()
//         .build()
//         .unwrap();
//     // یک نمونه سراسری و thread-safe از کلاینت که از api.rs قابل دسترسی است
//     pub static ref QUIC_CLIENT: Mutex<QuicClient> = Mutex::new(QuicClient::new());
// }

// pub struct QuicClient {
//     connection: Option<Arc<Connection>>,
//     event_stream: Option<StreamSink<ServerEvent>>,
// }

// impl QuicClient {
//     pub fn new() -> Self {
//         Self {
//             connection: None,
//             event_stream: None,
//         }
//     }

//     pub fn set_event_stream(&mut self, s: StreamSink<ServerEvent>) {
//         self.event_stream = Some(s);
//     }

//     fn send_event(&self, event: ServerEvent) {
//         if let Some(stream) = &self.event_stream {
//             if let Err(e) = stream.add(event) {
//                 error!("Failed to send event to Flutter: {:?}", e);
//             }
//         }
//     }

//     pub async fn connect(
//         &mut self,
//         server_addr: SocketAddr,
//         server_cert_der: Vec<u8>,
//     ) -> Result<()> {
//         let client_cfg = configure_client(server_cert_der)?;
//         let mut endpoint = Endpoint::client("0.0.0.0:0".parse()?)?;
//         endpoint.set_default_client_config(client_cfg);

//         info!("Connecting to server at {}", server_addr);
//         let conn = endpoint.connect(server_addr, "localhost")?.await?;
//         let connection = Arc::new(conn);
//         self.connection = Some(connection.clone());

//         self.send_event(ServerEvent::Connected);
//         info!("Connection established.");

//         let event_stream_clone = self.event_stream.clone();
//         TOKIO_RUNTIME.spawn(async move {
//             listen_for_server_messages(connection, event_stream_clone).await;
//         });

//         Ok(())
//     }

//     async fn send_message(&self, message: ClientToServer) -> Result<()> {
//         let connection = self
//             .connection
//             .as_ref()
//             .ok_or_else(|| anyhow!("Not connected"))?;
//         let (mut send, _recv) = connection.open_bi().await?;
//         let encoded = message.encode_to_vec();
//         send.write_all(&encoded).await?;
//         send.finish()?;
//         Ok(())
//     }

//     pub async fn send_canvas_command(&self, command_json: String, timestamp_ms: i64) -> Result<()> {
//         let cmd = crate::proto::CanvasCommand {
//             command_json,
//             timestamp_ms,
//         };
//         let msg = ClientToServer {
//             payload: Some(client_to_server::Payload::CanvasCommand(cmd)),
//         };
//         self.send_message(msg).await
//     }

//     pub async fn send_audio_chunk(&self, data: Vec<u8>, sequence: i64) -> Result<()> {
//         let chunk = crate::proto::AudioChunk { data, sequence };
//         let msg = ClientToServer {
//             payload: Some(client_to_server::Payload::AudioChunk(chunk)),
//         };
//         self.send_message(msg).await
//     }
// }
// // این تابع در پس‌زمینه اجرا می‌شود و به پیام‌های ارسالی از سرور گوش می‌دهد
// async fn listen_for_server_messages(
//     connection: Arc<Connection>,
//     event_stream: Option<StreamSink<ServerEvent>>,
// ) {
//     loop {
//         match connection.accept_uni().await {
//             Ok(mut recv) => {
//                 info!("Accepted a unidirectional stream from server.");
//                 if let Some(data) = recv.read_to_end(1_000_000).await.ok() {
//                     if let Ok(msg) = ServerToClient::decode(&data[..]) {
//                         if let Some(payload) = msg.payload {
//                             let event = match payload {
//                                 server_to_client::Payload::ServerEvent(e) => {
//                                     ServerEvent::ServerMessage { message: e }
//                                 }
//                                 server_to_client::Payload::DataPayload(d) => {
//                                     ServerEvent::DataPayload { data: d }
//                                 }
//                             };
//                             if let Some(stream) = &event_stream {
//                                 let _ = stream.add(event);
//                             }
//                         }
//                     }
//                 }
//             }
//             Err(quinn::ConnectionError::ApplicationClosed { .. }) => {
//                 info!("Connection closed by server.");
//                 if let Some(stream) = &event_stream {
//                     let _ = stream.add(ServerEvent::Disconnected);
//                 }
//                 break;
//             }
//             Err(e) => {
//                 error!("Error accepting stream: {}", e);
//                 if let Some(stream) = &event_stream {
//                     let _ = stream.add(ServerEvent::Error {
//                         message: e.to_string(),
//                     });
//                 }
//                 tokio::time::sleep(Duration::from_secs(1)).await;
//             }
//         }
//     }
// }

// // پیکربندی کلاینت برای اعتماد به گواهی self-signed سرور
// fn configure_client(server_cert_der: Vec<u8>) -> Result<ClientConfig> {
//     let server_cert = CertificateDer::from(server_cert_der);
//     let mut roots = rustls::RootCertStore::empty();
//     roots.add(server_cert)?;

//     // 1. ابتدا کانفیگ rustls را می‌سازیم
//     let rustls_client_config = rustls::ClientConfig::builder()
//         .with_root_certificates(roots)
//         .with_no_client_auth();

//     // 2. سپس آن را به کانفیگ مخصوص QUIC تبدیل می‌کنیم
//     let quic_crypto_config = QuicClientConfig::try_from(rustls_client_config)?;

//     // 3. در نهایت، کانفیگ QUIC را به کلاینت quinn می‌دهیم
//     Ok(ClientConfig::new(Arc::new(quic_crypto_config)))
// }
