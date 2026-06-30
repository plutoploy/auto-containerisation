# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app
# Copy package files first to leverage Docker cache
COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./
# Install dependencies
RUN \
  if [ -f "yarn.lock" ]; then yarn install --frozen-lockfile; \
  elif [ -f "pnpm-lock.yaml" ]; then npm install -g pnpm && pnpm install --frozen-lockfile; \
  else npm ci; \
  fi
# Copy source files
COPY . .
# Build
RUN npm run build

# Stage 2: Run
FROM node:20-alpine
WORKDIR /app
# Copy built files from builder
COPY --from=builder /app/dist ./dist

# Install production dependencies
COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./
RUN \
  if [ -f "yarn.lock" ]; then yarn install --frozen-lockfile --production; \
  elif [ -f "pnpm-lock.yaml" ]; then npm install -g pnpm && pnpm install --frozen-lockfile --prod; \
  else npm ci --omit=dev; \
  fi

ENV NODE_ENV=production

EXPOSE 3000
CMD ["node", "dist/server/index.js"]