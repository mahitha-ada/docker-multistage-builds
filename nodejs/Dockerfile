# Traditional approach - Single stage with everything
FROM node:18

WORKDIR /app

# Install system dependencies and build tools (stays in final image)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    curl \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy all files including development files
COPY . .

# Install ALL dependencies including dev dependencies (stays in final image)
RUN npm install

# Build the application (build tools and cache stay in final image)
RUN npm run build

EXPOSE 3000
CMD ["node", "dist/server.js"]
