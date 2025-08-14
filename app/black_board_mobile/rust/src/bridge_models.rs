#[derive(Debug, Clone)]
pub struct FlutterPoint {
    pub dx: f32,
    pub dy: f32,
}

#[derive(Debug, Clone)]
pub struct FlutterPathFull {
    pub path_id: u64,
    pub points: Vec<FlutterPoint>,
    pub color: u32,
    pub stroke_width: f32,
}

#[derive(Debug, Clone)]
pub struct FlutterPublicRoomInfo {
    pub room_id: String,
    pub name: String,
    pub participant_count: u32,
}

#[derive(Debug, Clone)]
pub struct EventMessage {
    pub data: Vec<u8>,
}
