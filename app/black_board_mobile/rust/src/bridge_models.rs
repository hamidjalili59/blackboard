// این ساختار عمومی است تا هم api و هم client بتوانند از آن استفاده کنند
// و flutter_rust_bridge نیز آن را برای تولید کد ببیند.
pub struct EventMessage {
    pub data: Vec<u8>,
}
