use crate::bridge_models::EventMessage;
use crate::client::ClientState;
use crate::proto::{room_message, AudioChunk, CanvasCommand};
use anyhow::Result;
use flutter_rust_bridge::frb;
use crate::frb_generated::StreamSink;
use lazy_static::lazy_static;
use std::sync::Arc;
use tokio::runtime::Runtime;
use tokio::sync::Mutex;
use tracing_subscriber::FmtSubscriber;

lazy_static! {
    static ref TOKIO_RUNTIME: Runtime = Runtime::new().expect("Failed to create Tokio runtime");
}
lazy_static! {
    static ref CLIENT_STATE: Arc<Mutex<ClientState>> = Arc::new(Mutex::new(
        ClientState::new().expect("Failed to initialize client state")
    ));
}

#[frb(init)]
pub fn init_app() {
    let subscriber = FmtSubscriber::builder()
        .with_max_level(tracing::Level::INFO)
        .finish();
    let _ = tracing::subscriber::set_global_default(subscriber);
}

/// Creates a room and returns its ID. Does not start streaming events.
pub fn create_room(server_addr: String, username: String) -> Result<String> {
    TOKIO_RUNTIME.block_on(async {
        let mut state = CLIENT_STATE.lock().await;
        state.create_room(server_addr, username).await
    })
}

/// Joins an existing room. Does not start streaming events.
pub fn join_room(server_addr: String, username: String, room_id: String) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let mut state = CLIENT_STATE.lock().await;
        state.join_room(server_addr, username, room_id).await
    })
}

/// Starts listening for events on the current connection and streams them to Flutter.
pub fn listen_events(events_sink: StreamSink<EventMessage>) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let state = CLIENT_STATE.lock().await;
        state.listen_events(Arc::new(Mutex::new(events_sink))).await
    })
}

pub fn send_canvas_command(command_json: String, timestamp_ms: i64) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let state = CLIENT_STATE.lock().await;
        let payload = room_message::Payload::CanvasCommand(CanvasCommand {
            command_json,
            timestamp_ms,
        });
        state.send_room_message(payload).await
    })
}

pub fn send_audio_chunk(data: Vec<u8>, sequence: i64) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let state = CLIENT_STATE.lock().await;
        let payload = room_message::Payload::AudioChunk(AudioChunk { data, sequence });
        state.send_room_message(payload).await
    })
}

pub fn disconnect() {
    TOKIO_RUNTIME.block_on(async {
        let mut state = CLIENT_STATE.lock().await;
        state.disconnect();
    })
}
