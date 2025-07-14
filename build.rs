// این اسکریپت در زمان بیلد اجرا می‌شود تا فایل پروتوباف را به کد راست تبدیل کند.
fn main() -> Result<(), std::io::Error> {
    // با حذف کردن خط .out_dir()، فایل تولید شده به صورت خودکار در مسیر OUT_DIR
    // که توسط Cargo مدیریت می‌شود قرار می‌گیرد. این کار مشکل "file not found" را حل می‌کند.
    prost_build::Config::new()
        .compile_protos(&["src/proto/communication.proto"], &["src/proto/"])?;
    Ok(())
}
