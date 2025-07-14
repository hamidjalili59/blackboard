use anyhow::{anyhow, Result};
use prost::Message;
use quinn::{ClientConfig, Endpoint};
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::Arc;
use std::time::SystemTime;

// وارد کردن انواع داده‌ای جدید مورد نیاز از کتابخانه‌ها
use quinn::crypto::rustls::QuicClientConfig;
use rustls::client::danger::{HandshakeSignatureValid, ServerCertVerified, ServerCertVerifier};
use rustls::pki_types::{CertificateDer, ServerName, UnixTime};
use rustls::{crypto, DigitallySignedStruct, SignatureScheme};

// از نام پکیج شما (black_board_back) برای وارد کردن ماژول proto استفاده می‌کنیم
use black_board_back::proto::{
    client_to_server::Payload, AudioChunk, CanvasCommand, ClientToServer,
};

#[tokio::main]
async fn main() -> Result<()> {
    // اصلاح شد: یک ارائه‌دهنده رمزنگاری پیش‌فرض را برای rustls نصب می‌کنیم
    // این کار برای نسخه‌های جدید rustls الزامی است.
    rustls::crypto::ring::default_provider()
        .install_default()
        .expect("Failed to install rustls crypto provider");

    // گرفتن آرگومان از خط فرمان برای تعیین نوع پیام
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        println!("Usage: cargo run --bin client <canvas|audio>");
        return Ok(());
    }
    let message_type = &args[1];

    // --- تنظیمات کلاینت ---
    let server_addr = "127.0.0.1:12345".parse::<SocketAddr>()?;
    let client_addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 0);

    let mut endpoint = Endpoint::client(client_addr)?;
    endpoint.set_default_client_config(configure_client()?);

    println!("[Client] Connecting to server at {}...", server_addr);
    let conn = endpoint.connect(server_addr, "localhost")?.await?;
    println!("[Client] Connected successfully!");

    // --- ساخت پیام بر اساس آرگومان ورودی ---
    let message = match message_type.as_str() {
        "canvas" => {
            println!("[Client] Preparing CanvasCommand...");
            let timestamp = SystemTime::now()
                .duration_since(SystemTime::UNIX_EPOCH)?
                .as_millis() as i64;

            ClientToServer {
                payload: Some(Payload::CanvasCommand(CanvasCommand {
                    command_json: r#"{"action": "draw", "points": [10, 20, 30, 40]}"#.to_string(),
                    timestamp_ms: timestamp,
                })),
            }
        }
        "audio" => {
            println!("[Client] Preparing AudioChunk...");
            ClientToServer {
                payload: Some(Payload::AudioChunk(AudioChunk {
                    data: vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                    sequence: 1,
                })),
            }
        }
        _ => {
            return Err(anyhow!("Invalid message type. Use 'canvas' or 'audio'."));
        }
    };

    // --- ارسال پیام ---
    let (mut send, _recv) = conn.open_bi().await?;
    let mut buf = Vec::new();

    Message::encode(&message, &mut buf)?;

    send.write_all(&buf).await?;

    // متد .finish() دیگر Future نیست و نباید await شود.
    send.finish()?;

    println!("[Client] Message sent successfully.");

    // بستن اتصال
    conn.close(0u32.into(), b"done");
    endpoint.wait_idle().await;

    Ok(())
}

/// کانفیگ کلاینت برای پذیرش گواهی‌نامه self-signed سرور
fn configure_client() -> Result<ClientConfig> {
    // کانفیگ rustls را می‌سازیم و سپس آن را برای quinn آماده می‌کنیم
    let crypto = rustls::ClientConfig::builder()
        .dangerous()
        .with_custom_certificate_verifier(Arc::new(SkipServerVerification))
        .with_no_client_auth();

    // کانفیگ rustls را به یک کانفیگ سازگار با quinn تبدیل می‌کنیم
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
