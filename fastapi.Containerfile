FROM ghcr.io/astral-sh/uv:latest as builder
WORKDIR /app
COPY . .
RUN uv sync --no-lock

FROM ghcr.io/astral-sh/uv:latest
WORKDIR /app
COPY --from=builder /app .
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
