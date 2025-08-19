use crate::proto::{PathFull, RoomEvent};
use std::collections::HashMap;
use tokio::sync::broadcast;
use uuid::Uuid;

pub type ClientId = Uuid;
pub type ParticipantId = u32;
pub type RoomId = String;

#[derive(Clone)]
pub struct Participant {
    pub client_id: ClientId,
    pub participant_id: ParticipantId,
    pub username: String,
}

pub struct Room {
    pub id: RoomId,
    pub name: String,
    pub participants: HashMap<ClientId, Participant>,
    pub event_sender: broadcast::Sender<RoomEvent>, 
    pub audio_sender: broadcast::Sender<RoomEvent>,
    pub host_id: ClientId,
    pub active_paths: HashMap<u64, PathFull>,
    pub canvas_history: Vec<PathFull>,
    next_participant_id: ParticipantId,
}

impl Room {
    pub fn new(id: RoomId, name: String, host_id: ClientId) -> Self {
        let (event_sender, _) = broadcast::channel(256); // ظرفیت کمتر برای رویدادها
        let (audio_sender, _) = broadcast::channel(1024); // ظرفیت بیشتر برای صدا
        Room {
            id,
            name,
            participants: HashMap::new(),
            event_sender,
            audio_sender,
            host_id,
            active_paths: HashMap::new(),
            canvas_history: Vec::new(),
            next_participant_id: 1,
        }
    }

    pub fn add_participant(&mut self, client_id: ClientId, username: String) -> Participant {
        let participant_id = self.next_participant_id;
        self.next_participant_id += 1;

        let participant = Participant {
            client_id,
            participant_id,
            username,
        };

        self.participants.insert(client_id, participant.clone());
        participant
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
