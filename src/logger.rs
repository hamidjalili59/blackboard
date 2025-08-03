use crate::proto::RoomEvent;
use anyhow::Result;
use prost::Message; // برای انکود کردن پروتوباف اضافه شد
use std::path::{Path, PathBuf};
use tokio::fs::{File, OpenOptions};
use tokio::io::AsyncWriteExt;
use tracing::info;

/// این ساختار مسئولیت مدیریت فایل لاگ یک اتاق را بر عهده دارد.
pub struct RoomLogger {
    log_path: PathBuf,
}

impl RoomLogger {
    /// یک لاگر جدید برای یک اتاق مشخص ایجاد می‌کند.
    pub fn new(room_id: &str) -> Result<Self> {
        let dir = "records";
        std::fs::create_dir_all(dir)?;

        let timestamp = chrono::Utc::now().format("%Y%m%d-%H%M%S");
        // پسوند فایل را به bin تغییر می‌دهیم تا ماهیت باینری آن مشخص باشد
        let file_name = format!("{}_{}.binlog", room_id, timestamp);
        let log_path = Path::new(dir).join(file_name);

        info!(
            "Created binary log file for room {} at: {:?}",
            room_id, log_path
        );

        Ok(Self { log_path })
    }

    /// یک رویداد را با فرمت Length-Delimited Protobuf در فایل لاگ می‌نویسد.
    pub async fn log(&self, event: &RoomEvent) -> Result<()> {
        // 1. رویداد را به بایت‌های Protobuf سریالایز (انکود) می‌کنیم.
        let mut event_buf = Vec::new();
        event.encode(&mut event_buf)?;

        // 2. طول پیام انکود شده را به صورت یک عدد 32 بیتی (u32) محاسبه می‌کنیم.
        //    و آن را به بایت (با ترتیب big-endian) تبدیل می‌کنیم.
        let len_bytes = (event_buf.len() as u32).to_be_bytes();

        // 3. فایل را در حالت append (افزودن به انتها) باز می‌کنیم.
        let mut file: File = OpenOptions::new()
            .create(true)
            .append(true)
            .open(&self.log_path)
            .await?;

        // 4. ابتدا بایت‌های طول پیام و سپس خود پیام را در فایل می‌نویسیم.
        file.write_all(&len_bytes).await?;
        file.write_all(&event_buf).await?;

        Ok(())
    }
}
