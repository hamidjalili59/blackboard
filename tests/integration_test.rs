use anyhow::Result;
use black_board_back::proto::{
    client_to_server::Payload, AudioChunk, CanvasCommand, ClientToServer,
};
use prost::Message;
use quinn::{ClientConfig, Endpoint, ServerConfig};
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::Arc;
use tokio::sync::oneshot;

// وارد کردن انواع داده‌ای مورد نیاز از کتابخانه‌ها
use quinn::crypto::rustls::QuicClientConfig;
use rustls::client::danger::{HandshakeSignatureValid, ServerCertVerified, ServerCertVerifier};
use rustls::pki_types::{CertificateDer, PrivateKeyDer, ServerName, UnixTime};
use rustls::{crypto, DigitallySignedStruct, SignatureScheme};

// --- بخش سرور برای تست ---

/// یک سرور تست را در پس‌زمینه اجرا کرده و آدرس آن را برمی‌گرداند
async fn spawn_test_server() -> Result<SocketAddr> {
    // نصب ارائه‌دهنده رمزنگاری
    rustls::crypto::ring::default_provider()
        .install_default()
        .expect("Failed to install rustls crypto provider");

    // کانفیگ سرور را می‌سازیم
    let (server_config, _) = configure_test_server_crypto()?;
    // به سیستم‌عامل می‌گوییم یک پورت آزاد به ما اختصاص دهد
    let addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 0);
    let endpoint = Endpoint::server(server_config, addr)?;
    let server_addr = endpoint.local_addr()?;

    // یک کانال برای اطلاع از آماده شدن سرور
    let (tx, rx) = oneshot::channel();

    // سرور را در یک تسک جدید اجرا می‌کنیم
    tokio::spawn(async move {
        // به محض آماده شدن، به تست اصلی اطلاع می‌دهیم
        tx.send(()).unwrap();
        
        // منتظر یک اتصال از کلاینت تستی می‌مانیم
        if let Some(conn) = endpoint.accept().await {
            let connection = conn.await.expect("Connection failed");

            // منتظر دو stream از کلاینت می‌مانیم (یکی برای canvas، یکی برای audio)
            for _ in 0..2 {
                let _ = connection.accept_bi().await;
            }
        }
        // پس از دریافت اتصال، سرور تستی کار خود را تمام می‌کند
    });

    // منتظر می‌مانیم تا سرور کاملاً آماده شود
    rx.await?;
    Ok(server_addr)
}

/// کانفیگ رمزنگاری سرور را ایجاد می‌کند (کپی شده از main.rs)
fn configure_test_server_crypto() -> Result<(ServerConfig, Vec<u8>)> {
    let cert = rcgen::generate_simple_self_signed(vec!["localhost".into()])?;
    let cert_der_bytes = cert.cert.der().to_vec();
    let priv_key_der_bytes = cert.signing_key.serialize_der();
    let cert_chain = vec![CertificateDer::from(cert_der_bytes.clone())];
    let priv_key =
        PrivateKeyDer::from(rustls::pki_types::PrivatePkcs8KeyDer::from(priv_key_der_bytes));
    let server_config = ServerConfig::with_single_cert(cert_chain, priv_key)?;
    Ok((server_config, cert_der_bytes))
}

// --- بخش کلاینت برای تست ---

/// کانفیگ کلاینت را ایجاد می‌کند (کپی شده از client.rs)
fn configure_test_client() -> Result<ClientConfig> {
    let crypto = rustls::ClientConfig::builder()
        .dangerous()
        .with_custom_certificate_verifier(Arc::new(SkipServerVerification))
        .with_no_client_auth();
    let quic_crypto = QuicClientConfig::try_from(crypto)?;
    Ok(ClientConfig::new(Arc::new(quic_crypto)))
}

/// ساختار لازم برای نادیده گرفتن اعتبارسنجی گواهی‌نامه در تست
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

// --- تابع اصلی تست ---

#[tokio::test]
async fn test_server_and_client_communication() {
    // ۱. سرور تست را در پس‌زمینه اجرا می‌کنیم
    let server_addr = spawn_test_server()
        .await
        .expect("Failed to start test server");

    // ۲. کلاینت را برای اتصال به سرور تست آماده می‌کنیم
    let client_addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 0);
    let mut endpoint = Endpoint::client(client_addr).unwrap();
    endpoint
        .set_default_client_config(configure_test_client().unwrap());

    // ۳. به سرور متصل می‌شویم
    let conn = endpoint
        .connect(server_addr, "localhost")
        .unwrap()
        .await
        .expect("Client failed to connect");

    // ۴. پیام CanvasCommand را ارسال می‌کنیم
    println!("[Test] Sending CanvasCommand...");
    let canvas_msg = ClientToServer {
        payload: Some(Payload::CanvasCommand(CanvasCommand {
            command_json: "test_command".to_string(),
            timestamp_ms: 123,
        })),
    };
    let (mut send_canvas, _) = conn.open_bi().await.unwrap();
    let mut buf_canvas = Vec::new();
    canvas_msg.encode(&mut buf_canvas).unwrap();
    send_canvas.write_all(&buf_canvas).await.unwrap();
    send_canvas.finish().unwrap();
    println!("[Test] CanvasCommand sent.");

    // ۵. پیام AudioChunk را ارسال می‌کنیم
    println!("[Test] Sending AudioChunk...");
    let audio_msg = ClientToServer {
        payload: Some(Payload::AudioChunk(AudioChunk {
            data: vec![1, 2, 3],
            sequence: 1,
        })),
    };
    let (mut send_audio, _) = conn.open_bi().await.unwrap();
    let mut buf_audio = Vec::new();
    audio_msg.encode(&mut buf_audio).unwrap();
    send_audio.write_all(&buf_audio).await.unwrap();
    send_audio.finish().unwrap();
    println!("[Test] AudioChunk sent.");

    // ۶. اتصال را می‌بندیم
    conn.close(0u32.into(), b"test done");
    endpoint.wait_idle().await;

    // اگر کد به اینجا برسد، یعنی تمام مراحل بدون خطا انجام شده و تست موفقیت‌آمیز است.
    println!("[Test] Communication successful!");
}