#!/bin/bash
# run-examples.sh - Script to run all example applications

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Docker Multi-Stage Build Examples - Run Script${NC}"
echo "This script runs all example applications using their multi-stage Docker images."
echo ""

# Function to run an application
run_app() {
    local lang=$1
    local port=$2
    local image_tag="${lang}-multistage"
    local container_name="${lang}-app"
    
    echo -e "${BLUE}Running ${lang} application...${NC}"
    
    # Check if the image exists
    if ! docker image inspect "${image_tag}" > /dev/null 2>&1; then
        echo -e "${RED}Error: Image ${image_tag} not found.${NC}"
        echo "Please run the build-and-compare.sh script first."
        return 1
    fi
    
    # Stop and remove container if it already exists
    if docker ps -a | grep -q "${container_name}"; then
        echo "Stopping and removing existing container..."
        docker stop "${container_name}" > /dev/null 2>&1 || true
        docker rm "${container_name}" > /dev/null 2>&1 || true
    fi
    
    # Run the container
    echo "Starting container on port ${port}..."
    if [ "$lang" = "golang" ]; then
        # For Go, pass the PORT environment variable
        docker run -d -p "${port}:${port}" -e "PORT=${port}" --name "${container_name}" "${image_tag}"
    else
        docker run -d -p "${port}:${port}" --name "${container_name}" "${image_tag}"
    fi
    
    echo -e "${GREEN}${lang} application is running!${NC}"
    echo "Access it at: http://localhost:${port}"
    echo ""
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running or not installed.${NC}"
    exit 1
fi

# Define language-port mappings
declare -A ports
ports[nodejs]=3000
ports[python]=8000
ports[java]=8080
ports[golang]=8081

# Run each application
for lang in "${!ports[@]}"; do
    if [ -d "$lang" ]; then
        run_app "$lang" "${ports[$lang]}"
    else
        echo -e "${RED}Warning: Directory for ${lang} not found, skipping...${NC}"
    fi
done

echo -e "${GREEN}All applications are running!${NC}"
echo "To stop all containers, run: docker stop \$(docker ps -q)"
echo ""
echo "API endpoints for all applications:"
echo "  GET /api/items - List all items"
echo "  GET /api/items/{id} - Get a specific item"
echo "  POST /api/items - Create a new item"
