FROM docker.io/rust:latest as builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM docker.io/debian:bookworm-slim
WORKDIR /app
COPY --from=builder /app/target/release/app .
CMD ["./app"]
