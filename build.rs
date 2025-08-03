// build.rs

fn main() -> Result<(), std::io::Error> {
    // تمام تنظیمات مربوط به serde حذف شده است
    // و فقط کانفیگ پایه prost باقی مانده.
    prost_build::Config::new()
        .compile_protos(&["src/proto/communication.proto"], &["src/proto/"])?;

    Ok(())
}
