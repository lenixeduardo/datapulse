# syntax=docker/dockerfile:1.7

# 1) Dependências completas apenas para build.
FROM node:24.19.0-bookworm-slim AS deps
WORKDIR /app
COPY package.json ./
RUN npm install --no-audit --no-fund

# 2) Compila TypeScript em uma camada separada.
FROM deps AS build
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# 3) Instala SOMENTE dependências de produção.
FROM node:24.19.0-bookworm-slim AS prod-deps
WORKDIR /app
COPY package.json ./
RUN npm install --no-audit --no-fund --omit=dev && npm cache clean --force

# 4) Imagem final: sem TypeScript, sem source e sem devDependencies.
FROM node:24.19.0-bookworm-slim AS runtime
ENV NODE_ENV=production
WORKDIR /app

COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package.json ./
COPY public ./public

USER node
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3000/health').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"

CMD ["node", "dist/src/server.js"]
