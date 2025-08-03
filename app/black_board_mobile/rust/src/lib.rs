pub mod api;
// *** ماژول جدید برای ساختارهای داده اشتراکی ***
pub mod bridge_models;
mod client;
pub mod proto {
    include!(concat!(env!("OUT_DIR"), "/communication.rs"));
}
mod frb_generated;
