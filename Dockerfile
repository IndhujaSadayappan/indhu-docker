# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml* package-lock.json* ./

RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile || npm install

COPY . .

RUN pnpm build || npm run build


# ---------- Stage 2: Production ----------
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]