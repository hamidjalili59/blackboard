// build.rs

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // ۱. کامپایل کردن فایل Protobuf (بدون تغییر)
    println!("cargo:rerun-if-changed=src/proto/communication.proto");
    let mut config = prost_build::Config::new();
    // اضافه کردن قابلیت serde برای تبدیل آسان به JSON
    config.type_attribute(".", "#[derive(serde::Serialize, serde::Deserialize)]");
    config.extern_path(".serde", "::serde");
    config.compile_protos(&["src/proto/communication.proto"], &["src/proto/"])?;

    // ۲. تولید کد برای flutter_rust_bridge (روش استاندارد و پایدار)
    // این روش به صورت خودکار فایل کانفیگ (frb.yaml) را می‌خواند و تمام کارها را انجام می‌دهد.
    println!("cargo:rerun-if-changed=src/api.rs");
    println!("cargo:rerun-if-changed=frb.yaml");
    
    // *** رفع خطا: استفاده از نام صحیح کتابخانه ***
    // نام کتابخانه در کد lib_flutter_rust_bridge_codegen است.
    // lib_flutter_rust_bridge_codegen::build()?;

    Ok(())
}
