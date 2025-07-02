# Go Multi-Stage Build Example

This directory contains a simple Go HTTP server application that demonstrates the benefits of Docker multi-stage builds.

## Application Overview

This is a basic REST API with a simple web interface that:
- Serves a homepage with information about the API
- Provides endpoints to list, view, and create items
- Demonstrates a clean separation between build and runtime environments

## Prerequisites

- Docker installed on your machine
- Go 1.20+ (only needed for local development)

## Building with Docker

### Traditional Build (Single-Stage)

```bash
# Build the image using the traditional Dockerfile
docker build -t golang-traditional -f Dockerfile .

# Check the image size
docker images golang-traditional
```

### Multi-Stage Build

```bash
# Build the image using the multi-stage Dockerfile
docker build -t golang-multistage -f Dockerfile.secure .

# Check the image size
docker images golang-multistage
```

## Running the Application

```bash
# Run the container
docker run -p 8080:8080 golang-multistage

# Access the application
# Open http://localhost:8080 in your browser
```

## Size Comparison

You can run the following command to compare the sizes of both images:

```bash
docker images | grep golang
```

You should see a dramatic difference in size between the traditional and multi-stage builds. The Go example typically shows the most impressive size reduction of all the language examples.

## API Endpoints

- `GET /api/items` - List all items
- `GET /api/items/{id}` - Get a specific item
- `POST /api/items` - Create a new item (requires JSON body with name and description)

## Local Development

If you want to run the application locally without Docker:

```bash
# Run the application
go run main.go
```

## Key Multi-Stage Build Benefits Demonstrated

1. **Dramatically smaller image size**: The multi-stage build produces an extremely small image (often <10MB)
2. **Minimal attack surface**: Using the scratch image provides almost no attack surface
3. **Separation of concerns**: Build tools stay in the build stage, only the compiled binary in production
4. **Faster deployments**: Tiny images deploy and start almost instantly

## Dockerfile Explanation

The multi-stage Dockerfile uses two stages:

1. **Build stage**: Uses the full Go image to compile the application
2. **Production stage**: Uses the empty scratch image and only copies the compiled binary

This approach results in one of the smallest possible Docker images, which is a major advantage of Go applications in containerized environments.
