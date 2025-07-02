# Node.js Multi-Stage Build Example

This directory contains a simple Node.js Express application that demonstrates the benefits of Docker multi-stage builds.

## Application Overview

This is a basic REST API with a simple web interface that:
- Serves a homepage with information about the API
- Provides endpoints to list, view, and create items
- Demonstrates a clean separation between build and runtime environments

## Prerequisites

- Docker installed on your machine
- Node.js 14+ (only needed for local development)

## Building with Docker

### Traditional Build (Single-Stage)

```bash
# Build the image using the traditional Dockerfile
docker build -t nodejs-traditional -f Dockerfile .

# Check the image size
docker images nodejs-traditional
```

### Multi-Stage Build

```bash
# Build the image using the multi-stage Dockerfile
docker build -t nodejs-multistage -f Dockerfile.secure .

# Check the image size
docker images nodejs-multistage
```

## Running the Application

```bash
# Run the container
docker run -p 3000:3000 nodejs-multistage

# Access the application
# Open http://localhost:3000 in your browser
```

## Size Comparison

You can run the following command to compare the sizes of both images:

```bash
docker images | grep nodejs
```

You should see a significant difference in size between the traditional and multi-stage builds.

## API Endpoints

- `GET /api/items` - List all items
- `GET /api/items/:id` - Get a specific item
- `POST /api/items` - Create a new item (requires JSON body with name and description)

## Local Development

If you want to run the application locally without Docker:

```bash
# Install dependencies
npm install

# Start the server
npm start
```

## Key Multi-Stage Build Benefits Demonstrated

1. **Smaller image size**: The multi-stage build produces a significantly smaller image
2. **Reduced attack surface**: Fewer packages and dependencies in the final image
3. **Separation of concerns**: Build tools stay in the build stage, only runtime dependencies in production
4. **Faster deployments**: Smaller images deploy faster and start quicker

## Dockerfile Explanation

The multi-stage Dockerfile uses two stages:

1. **Build stage**: Uses the full Node.js image to install all dependencies and build the application
2. **Production stage**: Uses the smaller Alpine-based image and only copies the built application and production dependencies

This approach results in a much smaller and more secure final image.
