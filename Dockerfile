# --- مرحله 1: ساخت (Builder) ---
# از ایمیج رسمی Rust به عنوان پایه برای ساخت استفاده می‌کنیم.
FROM rust:1.77 AS builder

# دایرکتوری کاری را در کانتینر ایجاد می‌کنیم.
WORKDIR /usr/src/app

# فایل‌های وابستگی را کپی می‌کنیم.
COPY Cargo.toml Cargo.lock ./

# یک پروژه ساختگی ایجاد می‌کنیم تا وابستگی‌ها دانلود و کش شوند.
# این کار سرعت بیلد را در تغییرات بعدی کد افزایش می‌دهد.
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release

# حالا کدهای اصلی پروژه را کپی می‌کنیم.
COPY . .

# کش لایه‌های قبلی را حذف می‌کنیم و پروژه را به صورت کامل بیلد می‌کنیم.
RUN rm -f target/release/deps/quic_protobuf_server*
RUN cargo build --release

# --- مرحله 2: اجرا (Runner) ---
# از یک ایمیج سبک برای اجرای نهایی استفاده می‌کنیم تا حجم ایمیج کم باشد.
FROM debian:bullseye-slim

# نصب کتابخانه‌های مورد نیاز (مانند openssl)
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

# کپی کردن باینری کامپایل شده از مرحله ساخت.
COPY --from=builder /usr/src/app/target/release/quic_protobuf_server /usr/local/bin/quic_protobuf_server

# پورتی که سرور روی آن گوش می‌دهد را expose می‌کنیم.
# این پورت باید از نوع UDP باشد چون QUIC روی UDP کار می‌کند.
EXPOSE 12345/udp

# دستوری که هنگام اجرای کانتینر اجرا می‌شود.
CMD ["quic_protobuf_server"]
