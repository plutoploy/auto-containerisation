FROM docker.io/ruby:3.3 as builder
WORKDIR /app
COPY Gemfile* ./
RUN bundle install

FROM docker.io/ruby:3.3-slim
WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .
CMD ["ruby", "main.rb"]
