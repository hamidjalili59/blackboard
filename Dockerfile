FROM rust:1.78 as builder

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y protobuf-compiler

COPY Cargo.toml Cargo.lock ./

RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/black_board_back*

COPY . .

RUN cargo build --release --bin server

FROM debian:stable-slim

COPY --from=builder /usr/src/app/target/release/server /usr/local/bin/server

WORKDIR /usr/src/app
RUN mkdir records

EXPOSE 12345/udp

CMD ["server"]
