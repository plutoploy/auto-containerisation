FROM ghcr.io/astral-sh/uv:latest as builder
WORKDIR /app
COPY requirements.txt .
RUN uv sync

FROM ghcr.io/astral-sh/uv:latest
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY . .
CMD ["uv", "run", "python", "main.py"]
