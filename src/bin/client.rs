use anyhow::{anyhow, Result};
use prost::Message;
use quinn::{ClientConfig, Connection, Endpoint};
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::Arc;
use std::time::{SystemTime};
use tokio::time::Instant;

// وارد کردن انواع داده‌ای جدید مورد نیاز از کتابخانه‌ها
use quinn::crypto::rustls::QuicClientConfig;
use rustls::client::danger::{HandshakeSignatureValid, ServerCertVerified, ServerCertVerifier};
use rustls::pki_types::{CertificateDer, ServerName, UnixTime};
use rustls::{crypto, DigitallySignedStruct, SignatureScheme};

// از نام پکیج شما (black_board_back) برای وارد کردن ماژول proto استفاده می‌کنیم
use black_board_back::proto::{
    client_to_server::Payload, AudioChunk, CanvasCommand, ClientToServer,
};

// تعداد درخواست‌های همزمانی که می‌خواهید ارسال کنید
const NUM_REQUESTS: u32 = 1000;

/// این تابع یک درخواست تکی را به سرور ارسال می‌کند
async fn send_single_request(
    endpoint: &Endpoint,
    server_addr: SocketAddr,
    message: &ClientToServer,
) -> Result<()> {
    // اتصال به سرور
    let conn: Connection = endpoint.connect(server_addr, "localhost")?.await?;

    // باز کردن یک stream دوطرفه
    let (mut send, _recv) = conn.open_bi().await?;

    // انکود کردن و ارسال پیام
    let mut buf = Vec::new();
    Message::encode(message, &mut buf)?;
    send.write_all(&buf).await?;
    send.finish()?;

    // بستن اتصال
    conn.close(0u32.into(), b"done");

    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    // نصب ارائه‌دهنده رمزنگاری پیش‌فرض برای rustls
    rustls::crypto::ring::default_provider()
        .install_default()
        .expect("Failed to install rustls crypto provider");

    // گرفتن آرگومان از خط فرمان برای تعیین نوع پیام
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        println!("Usage: cargo run --bin client <canvas|audio> [num_requests]");
        println!("Example: cargo run --bin client canvas 5000");
        return Ok(());
    }
    let message_type = &args[1];
    let num_requests = if args.len() > 2 {
        args[2].parse::<u32>().unwrap_or(NUM_REQUESTS)
    } else {
        NUM_REQUESTS
    };

    // --- تنظیمات کلاینت ---
    let server_addr = "127.0.0.1:12345".parse::<SocketAddr>()?;
    let client_addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 0);

    let mut endpoint = Endpoint::client(client_addr)?;
    endpoint.set_default_client_config(configure_client()?);
    
    // استفاده از Arc برای به اشتراک‌گذاری امن endpoint بین تسک‌ها
    let endpoint = Arc::new(endpoint);

    // --- ساخت پیام نمونه ---
    let message = match message_type.as_str() {
        "canvas" => ClientToServer {
            payload: Some(Payload::CanvasCommand(CanvasCommand {
                command_json: r#"{"action": "stress_test"}"#.to_string(),
                timestamp_ms: 0,
            })),
        },
        "audio" => ClientToServer {
            payload: Some(Payload::AudioChunk(AudioChunk {
                data: vec![0; 10],
                sequence: 0,
            })),
        },
        _ => {
            return Err(anyhow!("Invalid message type. Use 'canvas' or 'audio'."));
        }
    };
    let message = Arc::new(message);

    // --- شروع تست بار ---
    println!(
        "🚀 Starting stress test with {} concurrent requests...",
        num_requests
    );
    let start_time = Instant::now();
    let mut tasks = Vec::new();

    for i in 0..num_requests {
        let endpoint_clone = Arc::clone(&endpoint);
        let message_clone = Arc::clone(&message);

        let task = tokio::spawn(async move {
            // برای هر تسک، یک پیام با sequence یا timestamp منحصر به فرد می‌سازیم
            let mut local_message = (*message_clone).clone();
            match &mut local_message.payload {
                Some(Payload::CanvasCommand(cmd)) => {
                    cmd.timestamp_ms = SystemTime::now()
                        .duration_since(SystemTime::UNIX_EPOCH)
                        .unwrap()
                        .as_millis() as i64;
                }
                Some(Payload::AudioChunk(chunk)) => {
                    chunk.sequence = i as i64;
                }
                None => {}
            }
            
            // ارسال درخواست
            if let Err(e) = send_single_request(&endpoint_clone, server_addr, &local_message).await {
                eprintln!("[Request {}] Failed: {}", i, e);
            }
        });

        tasks.push(task);
    }

    // منتظر می‌مانیم تا تمام تسک‌ها تمام شوند
    for task in tasks {
        task.await?;
    }

    let duration = start_time.elapsed();
    println!("\n✅ Test finished!");
    println!("--------------------");
    println!("Total requests: {}", num_requests);
    println!("Total time: {:?}", duration);
    println!(
        "Requests per second: {:.2}",
        num_requests as f64 / duration.as_secs_f64()
    );

    // Endpoint را به صورت دستی می‌بندیم
    endpoint.wait_idle().await;

    Ok(())
}

/// کانفیگ کلاینت برای پذیرش گواهی‌نامه self-signed سرور
fn configure_client() -> Result<ClientConfig> {
    let crypto = rustls::ClientConfig::builder()
        .dangerous()
        .with_custom_certificate_verifier(Arc::new(SkipServerVerification))
        .with_no_client_auth();

    let quic_crypto = QuicClientConfig::try_from(crypto)?;
    Ok(ClientConfig::new(Arc::new(quic_crypto)))
}

/// یک تاییدکننده گواهی‌نامه که هر گواهی‌نامه‌ای را قبول می‌کند (فقط برای تست!)
#[derive(Debug)]
struct SkipServerVerification;

impl ServerCertVerifier for SkipServerVerification {
    fn verify_server_cert(
        &self,
        _end_entity: &CertificateDer<'_>,
        _intermediates: &[CertificateDer<'_>],
        _server_name: &ServerName<'_>,
        _ocsp_response: &[u8],
        _now: UnixTime,
    ) -> Result<ServerCertVerified, rustls::Error> {
        Ok(ServerCertVerified::assertion())
    }

    fn verify_tls12_signature(
        &self,
        _message: &[u8],
        _cert: &CertificateDer<'_>,
        _dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, rustls::Error> {
        Ok(HandshakeSignatureValid::assertion())
    }

    fn verify_tls13_signature(
        &self,
        _message: &[u8],
        _cert: &CertificateDer<'_>,
        _dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, rustls::Error> {
        Ok(HandshakeSignatureValid::assertion())
    }

    fn supported_verify_schemes(&self) -> Vec<SignatureScheme> {
        crypto::ring::default_provider()
            .signature_verification_algorithms
            .supported_schemes()
    }
}
