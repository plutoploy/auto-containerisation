FROM golang:latest as builder
WORKDIR /app
COPY . .
RUN go build -o app

FROM golang:latest
WORKDIR /app
COPY --from=builder /app .
CMD ["app"]
