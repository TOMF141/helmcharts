#!/bin/bash
# Note: Not using 'set -e' to allow processing all charts even if one fails

# Azure Container Registry Helm Chart Publisher (Parallel Version)
# This script packages and publishes all Helm charts to Azure Container Registry in parallel

# Configuration
ACR_NAME="${ACR_NAME:-}"
CHARTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/charts" && pwd)"
NAMESPACE="${HELM_NAMESPACE:-helm}"
MAX_PARALLEL="${MAX_PARALLEL:-5}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage information
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Publish Helm charts to Azure Container Registry (in parallel)

OPTIONS:
    -r, --registry NAME    ACR registry name (without .azurecr.io)
    -n, --namespace NAME   Namespace in registry (default: helm)
    -c, --chart NAME       Publish specific chart only
    -j, --jobs NUM         Number of parallel jobs (default: 5)
    -d, --dry-run          Show what would be published without pushing
    -h, --help             Show this help message

ENVIRONMENT VARIABLES:
    ACR_NAME              Azure Container Registry name
    HELM_NAMESPACE        Namespace for charts in registry (default: helm)
    MAX_PARALLEL          Maximum parallel jobs (default: 5)

EXAMPLES:
    # Publish all charts with 5 parallel jobs
    $0 --registry myregistry

    # Publish with 10 parallel jobs
    $0 --registry myregistry --jobs 10

    # Publish specific chart
    $0 --registry myregistry --chart radarr

    # Dry run to see what would be published
    $0 --registry myregistry --dry-run

EOF
    exit 1
}

# Parse command line arguments
DRY_RUN=false
SPECIFIC_CHART=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--registry)
            ACR_NAME="$2"
            shift 2
            ;;
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -c|--chart)
            SPECIFIC_CHART="$2"
            shift 2
            ;;
        -j|--jobs)
            MAX_PARALLEL="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            usage
            ;;
    esac
done

# Validate ACR_NAME
if [ -z "$ACR_NAME" ]; then
    echo -e "${RED}Error: ACR registry name is required${NC}"
    echo "Set ACR_NAME environment variable or use --registry option"
    usage
fi

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo -e "${RED}Error: Helm is not installed${NC}"
    exit 1
fi

# Check if GNU parallel is installed
if ! command -v parallel &> /dev/null; then
    echo -e "${YELLOW}Warning: GNU parallel is not installed${NC}"
    echo "Install with: sudo apt install parallel"
    echo "Falling back to sequential processing..."
    PARALLEL_AVAILABLE=false
else
    PARALLEL_AVAILABLE=true
fi

# Construct registry URL
REGISTRY_URL="oci://$ACR_NAME.azurecr.io/$NAMESPACE"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}=== DRY RUN MODE ===${NC}"
    echo "Would publish to: $REGISTRY_URL"
    echo ""
fi

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}Azure Container Registry Helm Publisher${NC}"
echo -e "${BLUE}(Parallel Mode)${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo "Registry: $ACR_NAME.azurecr.io"
echo "Namespace: $NAMESPACE"
echo "Charts directory: $CHARTS_DIR"
echo "Parallel jobs: $MAX_PARALLEL"
echo ""

# Check if charts directory exists
if [ ! -d "$CHARTS_DIR" ]; then
    echo -e "${RED}Error: Charts directory not found: $CHARTS_DIR${NC}"
    exit 1
fi

# Function to publish a single chart
publish_chart() {
    local chart_dir="$1"
    local chart_name=$(basename "$chart_dir")
    local registry_url="$2"
    local dry_run="$3"
    
    # Check if Chart.yaml exists
    if [ ! -f "$chart_dir/Chart.yaml" ]; then
        echo -e "${RED}[$chart_name] ✗ No Chart.yaml found${NC}"
        return 1
    fi
    
    # Extract version from Chart.yaml
    local version=$(grep '^version:' "$chart_dir/Chart.yaml" | awk '{print $2}' | tr -d '"' | tr -d "'")
    
    if [ -z "$version" ]; then
        echo -e "${RED}[$chart_name] ✗ No version found in Chart.yaml${NC}"
        return 1
    fi
    
    echo -e "${BLUE}[$chart_name] Processing version $version${NC}"
    
    # Package the chart
    cd "$chart_dir"
    
    if [ "$dry_run" = "true" ]; then
        echo -e "${YELLOW}[$chart_name] → Would package and push to $registry_url${NC}"
        return 0
    fi
    
    # Package
    if ! helm package . > /dev/null 2>&1; then
        echo -e "${RED}[$chart_name] ✗ Failed to package${NC}"
        return 1
    fi
    
    # Find the generated .tgz file
    local tgz_file="${chart_name}-${version}.tgz"
    
    if [ ! -f "$tgz_file" ]; then
        echo -e "${RED}[$chart_name] ✗ Package file not found: $tgz_file${NC}"
        return 1
    fi
    
    # Push to ACR
    local push_output
    push_output=$(helm push "$tgz_file" "$registry_url" 2>&1)
    local push_exit_code=$?
    
    # Cleanup
    rm "$tgz_file" 2>/dev/null || true
    
    if [ $push_exit_code -eq 0 ] || echo "$push_output" | grep -q "Pushed\|Uploaded"; then
        echo -e "${GREEN}[$chart_name] ✓ Successfully published $version${NC}"
        return 0
    else
        echo -e "${RED}[$chart_name] ✗ Failed to push${NC}"
        echo -e "${RED}[$chart_name] Error: $push_output${NC}"
        return 1
    fi
}

# Export function for parallel
export -f publish_chart
export REGISTRY_URL DRY_RUN BLUE GREEN RED YELLOW NC

# Build list of charts to process
if [ -n "$SPECIFIC_CHART" ]; then
    chart_path="$CHARTS_DIR/$SPECIFIC_CHART"
    if [ ! -d "$chart_path" ]; then
        echo -e "${RED}Error: Chart not found: $SPECIFIC_CHART${NC}"
        exit 1
    fi
    CHART_LIST="$chart_path"
else
    CHART_LIST=$(find "$CHARTS_DIR" -mindepth 1 -maxdepth 1 -type d)
fi

# Process charts
if [ "$PARALLEL_AVAILABLE" = true ] && [ -z "$SPECIFIC_CHART" ]; then
    # Use GNU parallel for parallel processing
    echo -e "${BLUE}Processing charts in parallel (max $MAX_PARALLEL jobs)...${NC}"
    echo ""
    
    echo "$CHART_LIST" | parallel -j "$MAX_PARALLEL" --line-buffer \
        publish_chart {} "$REGISTRY_URL" "$DRY_RUN"
    
    exit_code=$?
else
    # Sequential processing
    echo -e "${BLUE}Processing charts sequentially...${NC}"
    echo ""
    
    SUCCESS_COUNT=0
    FAIL_COUNT=0
    
    for chart_dir in $CHART_LIST; do
        if [ -d "$chart_dir" ]; then
            if publish_chart "$chart_dir" "$REGISTRY_URL" "$DRY_RUN"; then
                ((SUCCESS_COUNT++))
            else
                ((FAIL_COUNT++))
            fi
            echo ""
        fi
    done
    
    # Summary
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}Summary${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo -e "${GREEN}Successful: $SUCCESS_COUNT${NC}"
    if [ $FAIL_COUNT -gt 0 ]; then
        echo -e "${RED}Failed: $FAIL_COUNT${NC}"
        exit_code=1
    else
        exit_code=0
    fi
    echo ""
fi

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}This was a dry run. No charts were actually published.${NC}"
    echo "Remove --dry-run flag to publish charts."
fi

exit ${exit_code:-0}
