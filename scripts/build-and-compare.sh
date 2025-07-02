#!/bin/bash
# build-and-compare.sh - Script to build and compare Docker images for all examples

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Docker Multi-Stage Build Examples - Build and Compare Script${NC}"
echo "This script builds both traditional and multi-stage Docker images for all examples"
echo "and compares their sizes to demonstrate the benefits of multi-stage builds."
echo ""

# Function to build and compare images for a specific language
build_and_compare() {
    local lang=$1
    local traditional_tag="${lang}-traditional"
    local multistage_tag="${lang}-multistage"
    
    echo -e "${BLUE}Building ${lang} images...${NC}"
    
    # Navigate to language directory
    cd "${lang}"
    
    # Build traditional image
    echo "Building traditional image..."
    docker build -t "${traditional_tag}" -f Dockerfile .
    
    # Build multi-stage image
    echo "Building multi-stage image..."
    docker build -t "${multistage_tag}" -f Dockerfile.secure .
    
    # Get image sizes
    traditional_size=$(docker images "${traditional_tag}" --format "{{.Size}}")
    multistage_size=$(docker images "${multistage_tag}" --format "{{.Size}}")
    
    # Convert sizes to MB for calculation (assuming sizes are in MB or GB format)
    traditional_mb=$(echo "${traditional_size}" | sed 's/MB//' | sed 's/GB/*1000/' | bc)
    multistage_mb=$(echo "${multistage_size}" | sed 's/MB//' | sed 's/GB/*1000/' | bc)
    
    # Calculate percentage reduction
    reduction=$(echo "scale=2; (${traditional_mb} - ${multistage_mb}) / ${traditional_mb} * 100" | bc)
    
    echo -e "${GREEN}Results for ${lang}:${NC}"
    echo "Traditional image size: ${traditional_size}"
    echo "Multi-stage image size: ${multistage_size}"
    echo -e "${GREEN}Size reduction: ${reduction}%${NC}"
    echo ""
    
    # Return to root directory
    cd ..
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running or not installed.${NC}"
    exit 1
fi

# Build and compare for each language
for lang in nodejs python java golang; do
    if [ -d "$lang" ]; then
        build_and_compare "$lang"
    else
        echo -e "${RED}Warning: Directory for ${lang} not found, skipping...${NC}"
    fi
done

echo -e "${GREEN}All builds completed successfully!${NC}"
echo "You can now run each application using:"
echo "  docker run -p <port>:<port> <image-name>"
echo ""
echo "Example ports:"
echo "  nodejs: 3000"
echo "  python: 8000"
echo "  java: 8080"
echo "  golang: 8080"
