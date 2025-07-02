FROM node:18 AS builder

WORKDIR /app

# Dependencies layer (changes less frequently)
COPY package*.json ./
RUN npm install

# Source code layer (changes more frequently)
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm install --only=production
EXPOSE 3000
CMD ["node", "dist/server.js"]
