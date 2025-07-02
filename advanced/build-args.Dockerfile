ARG VERSION=latest

FROM node:${VERSION} AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:${VERSION}-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /app/dist /app/dist
EXPOSE 3000
CMD ["node", "dist/server.js"]
