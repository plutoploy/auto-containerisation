FROM docker.io/golang:latest as builder
WORKDIR /app
ENV CGO_ENABLED=0
COPY . .
RUN go build -o app

FROM docker.io/golang:latest
WORKDIR /app
COPY --from=builder /app .
CMD ["app"]
