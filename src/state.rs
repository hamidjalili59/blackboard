use crate::proto::{CanvasCommand, RoomEvent};
use std::collections::HashMap;
use tokio::sync::broadcast;
use uuid::Uuid;

pub type ClientId = Uuid;
pub type RoomId = String;

#[derive(Clone)]
pub struct Participant {
    pub client_id: ClientId,
    pub username: String,
}

pub struct Room {
    pub id: RoomId,
    pub participants: HashMap<ClientId, Participant>,
    pub broadcast_sender: broadcast::Sender<RoomEvent>,
    pub host_id: ClientId,
    pub canvas_history: Vec<CanvasCommand>,
}

impl Room {
    pub fn new(id: RoomId, host_id: ClientId) -> Self {
        let (broadcast_sender, _) = broadcast::channel(1024);
        Room {
            id,
            participants: HashMap::new(),
            broadcast_sender,
            host_id,
            canvas_history: Vec::new(),
        }
    }
}

pub struct ServerState {
    pub rooms: HashMap<RoomId, Room>,
}

impl ServerState {
    pub fn new() -> Self {
        ServerState {
            rooms: HashMap::new(),
        }
    }
}
