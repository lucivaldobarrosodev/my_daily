# ---------- Estágio 1: build (instala dependências) ----------
FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

COPY . .

# ---------- Estágio 2: imagem final (runtime enxuto) ----------
FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app .

# Cria a pasta do banco SQLite e dá a posse ao usuário "node"
# ANTES de trocar de usuário (senão não tem permissão para criar)
RUN mkdir -p /etc/todos && chown -R node:node /etc/todos

EXPOSE 3000
USER node
CMD ["node", "src/index.js"]
