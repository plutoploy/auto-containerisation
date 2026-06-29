FROM docker.io/php:8.3-cli as builder
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y unzip && docker-php-ext-install pdo_mysql

FROM docker.io/php:8.3-cli
WORKDIR /app
COPY --from=builder /app .
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
