use crate::bridge_models::{EventMessage, FlutterPathFull, FlutterPoint};
use crate::client::ClientState;
use crate::frb_generated::StreamSink;
use crate::proto::{
    canvas_command, room_message, AudioChunk, CanvasCommand, PathAppend, PathEnd, PathStart,
};
use anyhow::Result;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use std::sync::Arc;
use tokio::runtime::Runtime;
use tokio::sync::Mutex;
use tracing::error;
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

pub fn create_room(server_addr: String, username: String) -> Result<String> {
    TOKIO_RUNTIME.block_on(async {
        let mut state = CLIENT_STATE.lock().await;
        state.create_room(server_addr, username).await
    })
}

pub fn join_room(
    server_addr: String,
    username: String,
    room_id: String,
) -> Result<Vec<FlutterPathFull>> {
    TOKIO_RUNTIME.block_on(async {
        let mut state = CLIENT_STATE.lock().await;
        state.join_room(server_addr, username, room_id).await
    })
}

pub fn listen_events(events_sink: StreamSink<EventMessage>) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let state = CLIENT_STATE.lock().await;
        state.listen_events(Arc::new(Mutex::new(events_sink))).await
    })
}

pub fn replay_room(
    server_addr: String,
    log_filename: String,
    events_sink: StreamSink<EventMessage>,
) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let mut replay_client = ClientState::new()?;
        replay_client
            .replay_room(server_addr, log_filename, Arc::new(Mutex::new(events_sink)))
            .await
    })
}

#[frb(sync)]
pub fn start_path(point: FlutterPoint, color: u32, stroke_width: f32) -> Result<u64> {
    let mut state = futures::executor::block_on(CLIENT_STATE.lock());
    let path_id = state.generate_path_id()?;
    let canvas_command = CanvasCommand {
        timestamp_ms: std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)?
            .as_millis() as i64,
        command_type: Some(canvas_command::CommandType::PathStart(PathStart {
            path_id,
            point: Some(crate::proto::Point {
                dx: point.dx,
                dy: point.dy,
            }),
            color,
            stroke_width,
        })),
    };
    let payload = room_message::Payload::CanvasCommand(canvas_command);

    TOKIO_RUNTIME.spawn(async move {
        let state = CLIENT_STATE.lock().await;
        if let Err(e) = state.send_room_message(payload).await {
            error!("Failed to send start_path: {}", e);
        }
    });

    Ok(path_id)
}

pub fn append_to_path(path_id: u64, point: FlutterPoint) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let state = CLIENT_STATE.lock().await;
        let canvas_command = CanvasCommand {
            timestamp_ms: std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)?
                .as_millis() as i64,
            command_type: Some(canvas_command::CommandType::PathAppend(PathAppend {
                path_id,
                point: Some(crate::proto::Point {
                    dx: point.dx,
                    dy: point.dy,
                }),
            })),
        };
        let payload = room_message::Payload::CanvasCommand(canvas_command);
        state.send_room_message(payload).await
    })
}

pub fn end_path(path_id: u64) -> Result<()> {
    TOKIO_RUNTIME.block_on(async {
        let state = CLIENT_STATE.lock().await;
        let canvas_command = CanvasCommand {
            timestamp_ms: std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)?
                .as_millis() as i64,
            command_type: Some(canvas_command::CommandType::PathEnd(PathEnd { path_id })),
        };
        let payload = room_message::Payload::CanvasCommand(canvas_command);
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
