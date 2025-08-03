use crate::proto::RoomEvent;
use std::collections::HashMap;
use tokio::sync::broadcast;
use uuid::Uuid;

pub type ClientId = Uuid;
pub type RoomId = String;

/// نمایانگر یک شرکت‌کننده (کلاینت) در یک اتاق است.
/// این ساختار ساده شده و فقط اطلاعات ضروری را نگه می‌دارد.
#[derive(Clone)] // Clone را اضافه می‌کنیم تا بتوانیم از آن کپی تهیه کنیم
pub struct Participant {
    pub client_id: ClientId,
    pub username: String,
}

/// نمایانگر یک اتاق (Room) در سرور است.
pub struct Room {
    pub id: RoomId,
    pub participants: HashMap<ClientId, Participant>,
    pub broadcast_sender: broadcast::Sender<RoomEvent>,
    // TODO: در مراحل بعدی، اینجا یک هندلر برای ذخیره‌سازی داده‌ها اضافه خواهیم کرد
}

impl Room {
    /// یک اتاق جدید با شناسه مشخص می‌سازد.
    pub fn new(id: RoomId) -> Self {
        let (broadcast_sender, _) = broadcast::channel(1024);
        Room {
            id,
            participants: HashMap::new(),
            broadcast_sender,
        }
    }
}

/// وضعیت کلی سرور را نگهداری می‌کند.
pub struct ServerState {
    pub rooms: HashMap<RoomId, Room>,
}

impl ServerState {
    /// یک وضعیت جدید و خالی برای سرور ایجاد می‌کند.
    pub fn new() -> Self {
        ServerState {
            rooms: HashMap::new(),
        }
    }
}
