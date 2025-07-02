#!/bin/bash

# Docker Multistage Build Demonstration Script
# This script builds all examples and shows the dramatic size differences

set -e

echo "🐳 Docker Multistage Build Size Comparison Demo"
echo "================================================"
echo ""

# Function to build and compare sizes
build_and_compare() {
    local lang=$1
    local dir=$2
    
    echo "Building $lang examples..."
    cd "$dir"
    
    # Build traditional image
    echo "  → Building traditional $lang image..."
    docker build -f Dockerfile -t "${lang}-traditional" . > /dev/null 2>&1
    
    # Build multistage image  
    echo "  → Building multistage $lang image..."
    docker build -f Dockerfile.secure -t "${lang}-multistage" . > /dev/null 2>&1
    
    cd ..
    echo "  $lang builds completed"
    echo ""
}

# Build all examples
echo "Starting builds (this may take a few minutes)..."
echo ""

build_and_compare "golang" "golang"
build_and_compare "nodejs" "nodejs" 
build_and_compare "python" "python"
build_and_compare "java" "java"

echo "Final Size Comparison:"
echo "========================"
echo ""

# Get image sizes and calculate savings
get_size() {
    docker images --format "{{.Size}}" "$1" | head -1
}

calculate_savings() {
    local traditional=$1
    local multistage=$2
    
    # Convert sizes to MB for calculation
    local trad_mb=0
    local multi_mb=0
    
    # Parse traditional size
    if [[ $traditional == *"GB" ]]; then
        trad_mb=$(echo "$traditional" | sed 's/GB//' | awk '{print $1 * 1000}')
    elif [[ $traditional == *"MB" ]]; then
        trad_mb=$(echo "$traditional" | sed 's/MB//')
    elif [[ $traditional == *"kB" ]]; then
        trad_mb=$(echo "$traditional" | sed 's/kB//' | awk '{print $1 / 1000}')
    fi
    
    # Parse multistage size
    if [[ $multistage == *"GB" ]]; then
        multi_mb=$(echo "$multistage" | sed 's/GB//' | awk '{print $1 * 1000}')
    elif [[ $multistage == *"MB" ]]; then
        multi_mb=$(echo "$multistage" | sed 's/MB//')
    elif [[ $multistage == *"kB" ]]; then
        multi_mb=$(echo "$multistage" | sed 's/kB//' | awk '{print $1 / 1000}')
    fi
    
    if [[ $trad_mb != "0" && $multi_mb != "0" ]]; then
        local savings=$(awk "BEGIN {printf \"%.1f\", (($trad_mb - $multi_mb) / $trad_mb) * 100}")
        echo "${savings}%"
    else
        echo "N/A"
    fi
}

# Display results
printf "%-12s %-15s %-15s %-10s\n" "Language" "Traditional" "Multistage" "Savings"
printf "%-12s %-15s %-15s %-10s\n" "--------" "-----------" "-----------" "-------"

for lang in golang nodejs python java; do
    trad_size=$(get_size "${lang}-traditional")
    multi_size=$(get_size "${lang}-multistage") 
    savings=$(calculate_savings "$trad_size" "$multi_size")
    
    printf "%-12s %-15s %-15s %-10s\n" "$lang" "$trad_size" "$multi_size" "$savings"
done

echo ""
echo "Demo completed! Key takeaways:"
echo "- Multistage builds can reduce image sizes by up to 89%"
echo "- Smaller images = faster deployments & less storage costs"
echo "- Production images contain only runtime dependencies"
echo "- Build tools and source code are excluded from final images"
echo ""
echo "See SIZE_COMPARISON.md for detailed analysis"
