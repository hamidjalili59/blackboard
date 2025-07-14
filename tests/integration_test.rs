// // این یک تست یکپارچه‌سازی است.
// // برای اجرای آن از دستور `cargo test` استفاده کنید.

// use anyhow::Result;
// use prost::Message;
// use quinn::{rustls, ClientConfig, Endpoint};
// use std::net::{IpAddr, Ipv4Addr, SocketAddr};
// use std::sync::Arc;
// use std::time::Duration;

// // کدهای ماژول اصلی را وارد می‌کنیم تا به پیام‌های protobuf دسترسی داشته باشیم
// mod server_logic {
//     // این یک ترفند برای دسترسی به کدهای main.rs در تست است
//     // توجه: این فایل باید در ریشه پروژه باشد تا کار کند
//     include!("../src/main.rs");
// }

// use server_logic::proto::{client_to_server::Payload, AudioChunk, CanvasCommand, ClientToServer};

// /// یک کلاینت QUIC ساده برای تست
// async fn run_client(server_addr: SocketAddr) -> Result<()> {
//     let client_addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 0);
//     let mut endpoint = Endpoint::client(client_addr)?;

//     // کانفیگ کلاینت برای پذیرش گواهی‌نامه self-signed سرور
//     let mut crypto = rustls::ClientConfig::builder()
//         .with_safe_defaults()
//         .with_custom_certificate_verifier(Arc::new(SkipServerVerification))
//         .with_no_client_auth();
    
//     // پروتکل ALPN را برای QUIC تنظیم کنید
//     crypto.alpn_protocols = vec![b"h3".to_vec()]; // یا هر پروتکل دیگری که سرور انتظار دارد

//     endpoint.set_default_client_config(ClientConfig::new(Arc::new(crypto)));

//     // اتصال به سرور
//     let conn = endpoint.connect(server_addr, "localhost")?.await?;
//     println!("[Client] Connected to server.");

//     // 1. ارسال پیام CanvasCommand
//     let canvas_command = CanvasCommand {
//         command_json: r#"{"type": "line", "from": [10, 20], "to": [100, 150]}"#.to_string(),
//         timestamp_ms: 1234567890,
//     };
//     let client_msg_canvas = ClientToServer {
//         payload: Some(Payload::CanvasCommand(canvas_command)),
//     };
//     let mut buf_canvas = Vec::new();
//     client_msg_canvas.encode(&mut buf_canvas)?;

//     let (mut send, _recv) = conn.open_bi().await?;
//     send.write_all(&buf_canvas).await?;
//     send.finish().await?; // بستن stream برای اطلاع سرور
//     println!("[Client] Sent CanvasCommand.");

//     // 2. ارسال پیام AudioChunk
//     let audio_chunk = AudioChunk {
//         data: vec![0, 1, 2, 3, 4, 5, 6, 7],
//         sequence: 1,
//     };
//     let client_msg_audio = ClientToServer {
//         payload: Some(Payload::AudioChunk(audio_chunk)),
//     };
//     let mut buf_audio = Vec::new();
//     client_msg_audio.encode(&mut buf_audio)?;

//     let (mut send, _recv) = conn.open_bi().await?;
//     send.write_all(&buf_audio).await?;
//     send.finish().await?;
//     println!("[Client] Sent AudioChunk.");
    
//     // بستن اتصال
//     conn.close(0u32.into(), b"done");
//     endpoint.wait_idle().await;

//     Ok(())
// }

// #[tokio::test]
// async fn test_server_communication() {
//     // سرور را در یک ترد جداگانه اجرا می‌کنیم
//     tokio::spawn(async {
//         // برای سادگی، فرض می‌کنیم سرور بدون خطا اجرا می‌شود
//         server_logic::main().await.unwrap();
//     });

//     // کمی صبر می‌کنیم تا سرور آماده شود
//     tokio::time::sleep(Duration::from_secs(1)).await;

//     let server_addr = "127.0.0.1:12345".parse().unwrap();

//     // کلاینت را اجرا می‌کنیم
//     let result = run_client(server_addr).await;
//     assert!(result.is_ok(), "Client failed to run: {:?}", result.err());
// }


// /// یک تاییدکننده گواهی‌نامه که هر گواهی‌نامه‌ای را قبول می‌کند (فقط برای تست!)
// struct SkipServerVerification;

// impl rustls::client::ServerCertVerifier for SkipServerVerification {
//     fn verify_server_cert(
//         &self,
//         _end_entity: &rustls::Certificate,
//         _intermediates: &[rustls::Certificate],
//         _server_name: &rustls::ServerName,
//         _scts: &mut dyn Iterator<Item = &[u8]>,
//         _ocsp_response: &[u8],
//         _now: std::time::SystemTime,
//     ) -> Result<rustls::client::ServerCertVerified, rustls::Error> {
//         Ok(rustls::client::ServerCertVerified::assertion())
//     }
// }
