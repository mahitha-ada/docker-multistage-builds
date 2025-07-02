# Python Multi-Stage Build Example

This directory contains a simple Python Flask application that demonstrates the benefits of Docker multi-stage builds.

## Application Overview

This is a basic REST API with a simple web interface that:
- Serves a homepage with information about the API
- Provides endpoints to list, view, and create items
- Demonstrates a clean separation between build and runtime environments using Poetry

## Prerequisites

- Docker installed on your machine
- Python 3.11+ and Poetry (only needed for local development)

## Building with Docker

### Traditional Build (Single-Stage)

```bash
# Build the image using the traditional Dockerfile
docker build -t python-traditional -f Dockerfile .

# Check the image size
docker images python-traditional
```

### Multi-Stage Build

```bash
# Build the image using the multi-stage Dockerfile
docker build -t python-multistage -f Dockerfile.secure .

# Check the image size
docker images python-multistage
```

## Running the Application

```bash
# Run the container
docker run -p 8000:8000 python-multistage

# Access the application
# Open http://localhost:8000 in your browser
```

## Size Comparison

You can run the following command to compare the sizes of both images:

```bash
docker images | grep python
```

You should see a significant difference in size between the traditional and multi-stage builds.

## API Endpoints

- `GET /api/items` - List all items
- `GET /api/items/<id>` - Get a specific item
- `POST /api/items` - Create a new item (requires JSON body with name and description)

## Local Development

If you want to run the application locally without Docker:

```bash
# Install Poetry if you don't have it
pip install poetry

# Install dependencies
poetry install

# Start the server
poetry run python app/main.py
```

## Key Multi-Stage Build Benefits Demonstrated

1. **Smaller image size**: The multi-stage build produces a significantly smaller image
2. **Reduced attack surface**: Fewer packages and dependencies in the final image
3. **Separation of concerns**: Build tools stay in the build stage, only runtime dependencies in production
4. **Faster deployments**: Smaller images deploy faster and start quicker

## Dockerfile Explanation

The multi-stage Dockerfile uses two stages:

1. **Build stage**: Uses the full Python image to install Poetry and all dependencies
2. **Production stage**: Uses the smaller slim image and only copies the installed packages and application code

This approach results in a much smaller and more secure final image.
