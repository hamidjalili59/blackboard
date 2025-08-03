// src/lib.rs

pub mod proto {
    include!(concat!(env!("OUT_DIR"), "/communication.rs"));
}

pub mod state;

// ماژول جدید برای ذخیره‌سازی رویدادهای جلسه
pub mod logger;
