FROM docker.io/oven/bun:latest as builder
WORKDIR /app
RUN bun ci
COPY . .
RUN bun run build

FROM docker.io/oven/bun:latest
COPY --from=builder /app/dist /app
WORKDIR /app
CMD ["bun", "run", "start"]
