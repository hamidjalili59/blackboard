// use anyhow::{anyhow, Result};
// use prost::Message;
// use quinn::{ClientConfig, Endpoint};
// use std::net::{IpAddr, Ipv4Addr, SocketAddr};
// use std::sync::Arc;
// use std::time::SystemTime;

// // وارد کردن انواع داده‌ای مورد نیاز از rustls و pki-types
// use rustls::client::danger::{ServerCertVerified, ServerCertVerifier};
// use rustls::pki_types::{CertificateDer, ServerName};

// // ماژول پروتوباف را از کتابخانه پروژه (lib.rs) وارد می‌کنیم
// use quic_protobuf_server::proto::{
//     client_to_server::Payload, AudioChunk, CanvasCommand, ClientToServer,
// };

// #[tokio::main]
// async fn main() -> Result<()> {
//     // گرفتن آرگومان از خط فرمان برای تعیین نوع پیام
//     let args: Vec<String> = std::env::args().collect();
//     if args.len() < 2 {
//         println!("Usage: cargo run --bin client <canvas|audio>");
//         return Ok(());
//     }
//     let message_type = &args[1];

//     // --- تنظیمات کلاینت ---
//     let server_addr = "127.0.0.1:12345".parse::<SocketAddr>()?;
//     let client_addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 0);

//     let mut endpoint = Endpoint::client(client_addr)?;
//     endpoint.set_default_client_config(configure_client());

//     println!("Connecting to server at {}...", server_addr);
//     let conn = endpoint.connect(server_addr, "localhost")?.await?;
//     println!("Connected successfully!");

//     // --- ساخت پیام بر اساس آرگومان ورودی ---
//     let message = match message_type.as_str() {
//         "canvas" => {
//             println!("Sending CanvasCommand...");
//             let timestamp = SystemTime::now()
//                 .duration_since(SystemTime::UNIX_EPOCH)?
//                 .as_millis() as i64;

//             ClientToServer {
//                 payload: Some(Payload::CanvasCommand(CanvasCommand {
//                     command_json: r#"{"action": "draw", "points": [10, 20, 30, 40]}"#.to_string(),
//                     timestamp_ms: timestamp,
//                 })),
//             }
//         }
//         "audio" => {
//             println!("Sending AudioChunk...");
//             ClientToServer {
//                 payload: Some(Payload::AudioChunk(AudioChunk {
//                     data: vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
//                     sequence: 1,
//                 })),
//             }
//         }
//         _ => {
//             return Err(anyhow!("Invalid message type. Use 'canvas' or 'audio'."));
//         }
//     };

//     // --- ارسال پیام ---
//     let (mut send, _recv) = conn.open_bi().await?;
//     let mut buf = Vec::new();
//     message.encode(&mut buf)?;

//     send.write_all(&buf).await?;
//     send.finish().await?; // مهم: استریم را می‌بندیم تا سرور بفهمد پیام تمام شده
//     println!("Message sent successfully.");

//     // بستن اتصال
//     conn.close(0u32.into(), b"done");
//     endpoint.wait_idle().await;

//     Ok(())
// }

// /// کانفیگ کلاینت برای پذیرش گواهی‌نامه self-signed سرور
// fn configure_client() -> ClientConfig {
//     let crypto = rustls::ClientConfig::builder()
//         .with_safe_defaults()
//         .with_custom_certificate_verifier(Arc::new(SkipServerVerification))
//         .with_no_client_auth();

//     ClientConfig::new(Arc::new(crypto))
// }

// /// یک تاییدکننده گواهی‌نامه که هر گواهی‌نامه‌ای را قبول می‌کند (فقط برای تست!)
// struct SkipServerVerification;

// // اصلاح شد: از ServerCertVerifier که از ماژول danger وارد شده استفاده می‌کنیم
// impl ServerCertVerifier for SkipServerVerification {
//     fn verify_server_cert(
//         &self,
//         _end_entity: &CertificateDer<'_>,
//         _intermediates: &[CertificateDer<'_>],
//         _server_name: &ServerName<'_>,
//         _scts: &mut dyn Iterator<Item = &[u8]>,
//         _ocsp_response: &[u8],
//         _now: std::time::SystemTime,
//     ) -> Result<ServerCertVerified, rustls::Error> {
//         // اصلاح شد: از ServerCertVerified که از ماژول danger وارد شده استفاده می‌کنیم
//         Ok(ServerCertVerified::assertion())
//     }
// }
