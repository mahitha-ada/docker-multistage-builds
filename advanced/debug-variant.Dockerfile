# Production stage
FROM node:18-alpine AS production
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY dist ./dist
EXPOSE 3000
CMD ["node", "dist/server.js"]

# Debug stage - extends production
FROM production AS debug
RUN apk add --no-cache curl htop strace
ENV NODE_ENV=development
ENV DEBUG=app:*
CMD ["node", "--inspect=0.0.0.0:9229", "dist/server.js"]
