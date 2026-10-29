FROM node:24-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends openssl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json package-lock.json ./
COPY prisma ./prisma
RUN npm ci && npx prisma generate

COPY . .
RUN chown -R node:node /app

ENV NODE_ENV=production
USER node
EXPOSE 3001

CMD ["sh", "-c", "npx prisma migrate deploy && node index.js"]
