use anyhow::Result;
use prost::Message;
use quinn::{Connection, Endpoint, ServerConfig};
use rustls_pki_types::{CertificateDer, PrivateKeyDer};
use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use tracing::{error, info, Level};
use tracing_subscriber;

// اصلاح شد: از کلمه کلیدی `crate` برای ارجاع به کتابخانه همین پروژه استفاده می‌کنیم
use black_board_back::proto::{
    client_to_server::Payload, ClientToServer,
};

#[tokio::main]
async fn main() -> Result<()> {
    // راه‌اندازی سیستم لاگ برای نمایش اطلاعات در کنسول
    tracing_subscriber::fmt().with_max_level(Level::INFO).init();

    info!("Starting QUIC server...");

    // آدرس و پورتی که سرور روی آن گوش می‌دهد
    let addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 12345);

    // ساخت گواهی‌نامه self-signed برای ارتباط امن QUIC
    let (server_config, _cert_der) = configure_server()?;

    // ساخت یک endpoint برای سرور
    let endpoint = Endpoint::server(server_config, addr)?;

    info!("Listening on {}", addr);

    // حلقه اصلی برای پذیرش اتصالات جدید
    while let Some(conn) = endpoint.accept().await {
        info!("New connection attempt...");
        tokio::spawn(async move {
            match conn.await {
                Ok(connection) => {
                    info!("Connection established with: {}", connection.remote_address());
                    if let Err(e) = handle_connection(connection).await {
                        error!("Connection handling failed: {}", e);
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

/// مدیریت یک اتصال برقرار شده از کلاینت
async fn handle_connection(connection: Connection) -> Result<()> {
    let remote_addr = connection.remote_address();

    // حلقه برای پذیرش stream های دوطرفه از کلاینت
    loop {
        match connection.accept_bi().await {
            Ok((_send_stream, mut recv_stream)) => {
                info!("New bidirectional stream opened by {}", remote_addr);
                tokio::spawn(async move {
                    if let Err(e) = handle_stream(&mut recv_stream).await {
                        error!("Stream handling failed for {}: {}", remote_addr, e);
                    }
                });
            }
            Err(quinn::ConnectionError::ApplicationClosed { .. }) => {
                info!("Connection closed by application: {}", remote_addr);
                break;
            }
            Err(e) => {
                error!("Error accepting stream from {}: {}", remote_addr, e);
                break;
            }
        }
    }

    Ok(())
}

/// خواندن و پردازش داده‌ها از یک stream
async fn handle_stream(recv_stream: &mut quinn::RecvStream) -> Result<()> {
    // خواندن داده‌ها از stream تا زمانی که بسته شود
    let data = recv_stream.read_to_end(65536).await?;
    info!("Received {} bytes of data.", data.len());

    // دیکود کردن پیام Protobuf
    let message = ClientToServer::decode(&data[..])?;

    // پردازش پیام بر اساس نوع آن (oneof)
    if let Some(payload) = message.payload {
        match payload {
            Payload::CanvasCommand(cmd) => {
                info!(
                    "Received Canvas Command: '{}' at timestamp {}",
                    cmd.command_json, cmd.timestamp_ms
                );
            }
            Payload::AudioChunk(chunk) => {
                info!(
                    "Received Audio Chunk: sequence {}, size {} bytes",
                    chunk.sequence,
                    chunk.data.len()
                );
            }
        }
    } else {
        info!("Received an empty payload.");
    }

    Ok(())
}

/// ساخت کانفیگ سرور با یک گواهی‌نامه self-signed
fn configure_server() -> Result<(ServerConfig, Vec<u8>)> {
    let cert = rcgen::generate_simple_self_signed(vec!["localhost".into()])?;
    
    let cert_der_bytes = cert.cert.der().to_vec();
    let priv_key_der_bytes = cert.signing_key.serialize_der();

    let cert_chain = vec![CertificateDer::from(cert_der_bytes.clone())];
    let priv_key = PrivateKeyDer::from(rustls_pki_types::PrivatePkcs8KeyDer::from(priv_key_der_bytes));

    let server_config = ServerConfig::with_single_cert(cert_chain, priv_key)?;

    Ok((server_config, cert_der_bytes))
}
