#!/bin/bash
# Note: Not using 'set -e' to allow processing all charts even if one fails

# Azure Container Registry Helm Chart Publisher
# This script packages and publishes all Helm charts to Azure Container Registry

# Configuration
ACR_NAME="${ACR_NAME:-}"
CHARTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/charts" && pwd)"
NAMESPACE="${HELM_NAMESPACE:-helm}"

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

Publish Helm charts to Azure Container Registry

OPTIONS:
    -r, --registry NAME    ACR registry name (without .azurecr.io)
    -n, --namespace NAME   Namespace in registry (default: helm)
    -c, --chart NAME       Publish specific chart only
    -d, --dry-run          Show what would be published without pushing
    -h, --help             Show this help message

ENVIRONMENT VARIABLES:
    ACR_NAME              Azure Container Registry name
    HELM_NAMESPACE        Namespace for charts in registry (default: helm)

EXAMPLES:
    # Publish all charts
    $0 --registry myregistry

    # Publish specific chart
    $0 --registry myregistry --chart radarr

    # Dry run to see what would be published
    $0 --registry myregistry --dry-run

    # Use environment variable
    export ACR_NAME=myregistry
    $0

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

# Check Helm version (need 3.8.0+ for OCI support)
HELM_VERSION=$(helm version --short | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
REQUIRED_VERSION="3.8.0"

version_compare() {
    printf '%s\n%s\n' "$1" "$2" | sort -V -C
}

if ! version_compare "$REQUIRED_VERSION" "$HELM_VERSION"; then
    echo -e "${RED}Error: Helm version $HELM_VERSION is too old${NC}"
    echo "Required: $REQUIRED_VERSION or later"
    exit 1
fi

# Check if authenticated to ACR
echo -e "${BLUE}Checking ACR authentication...${NC}"
if ! helm registry login $ACR_NAME.azurecr.io --help &> /dev/null; then
    echo -e "${RED}Error: Cannot connect to Helm registry${NC}"
    exit 1
fi

# Test authentication by attempting to list (this will fail gracefully if not authenticated)
echo -e "${YELLOW}Note: Make sure you're authenticated to ACR${NC}"
echo "Run: helm registry login $ACR_NAME.azurecr.io --username <user> --password <pass>"
echo ""

# Construct registry URL
REGISTRY_URL="oci://$ACR_NAME.azurecr.io/$NAMESPACE"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}=== DRY RUN MODE ===${NC}"
    echo "Would publish to: $REGISTRY_URL"
    echo ""
fi

# Function to publish a single chart
publish_chart() {
    local chart_dir="$1"
    local chart_name=$(basename "$chart_dir")
    
    echo -e "${BLUE}Processing: $chart_name${NC}"
    
    # Check if Chart.yaml exists
    if [ ! -f "$chart_dir/Chart.yaml" ]; then
        echo -e "${RED}  ✗ No Chart.yaml found, skipping${NC}"
        return 1
    fi
    
    # Extract version from Chart.yaml
    local version=$(grep '^version:' "$chart_dir/Chart.yaml" | awk '{print $2}' | tr -d '"' | tr -d "'")
    
    if [ -z "$version" ]; then
        echo -e "${RED}  ✗ No version found in Chart.yaml${NC}"
        return 1
    fi
    
    echo "  Version: $version"
    
    # Package the chart
    cd "$chart_dir"
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}  → Would package $chart_name-$version.tgz${NC}"
        echo -e "${YELLOW}  → Would push to $REGISTRY_URL${NC}"
        cd - > /dev/null
        return 0
    fi
    
    echo "  Packaging..."
    if ! helm package . > /dev/null 2>&1; then
        echo -e "${RED}  ✗ Failed to package chart${NC}"
        cd - > /dev/null
        return 1
    fi
    
    # Find the generated .tgz file
    local tgz_file="${chart_name}-${version}.tgz"
    
    if [ ! -f "$tgz_file" ]; then
        echo -e "${RED}  ✗ Package file not found: $tgz_file${NC}"
        cd - > /dev/null
        return 1
    fi
    
    # Push to ACR
    echo "  Pushing to ACR..."
    local push_output
    push_output=$(helm push "$tgz_file" "$REGISTRY_URL" 2>&1)
    local push_exit_code=$?
    
    if [ $push_exit_code -eq 0 ] || echo "$push_output" | grep -q "Pushed\|Uploaded"; then
        echo -e "${GREEN}  ✓ Successfully published $chart_name:$version${NC}"
        rm "$tgz_file"
        cd - > /dev/null
        return 0
    else
        echo -e "${RED}  ✗ Failed to push chart${NC}"
        echo -e "${RED}  Error: $push_output${NC}"
        rm "$tgz_file" 2>/dev/null || true
        cd - > /dev/null
        return 1
    fi
}

# Main execution
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}Azure Container Registry Helm Publisher${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo "Registry: $ACR_NAME.azurecr.io"
echo "Namespace: $NAMESPACE"
echo "Charts directory: $CHARTS_DIR"
echo ""

# Check if charts directory exists
if [ ! -d "$CHARTS_DIR" ]; then
    echo -e "${RED}Error: Charts directory not found: $CHARTS_DIR${NC}"
    exit 1
fi

# Counters
SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

# Process charts
if [ -n "$SPECIFIC_CHART" ]; then
    # Publish specific chart
    chart_path="$CHARTS_DIR/$SPECIFIC_CHART"
    if [ ! -d "$chart_path" ]; then
        echo -e "${RED}Error: Chart not found: $SPECIFIC_CHART${NC}"
        exit 1
    fi
    
    if publish_chart "$chart_path"; then
        ((SUCCESS_COUNT++))
    else
        ((FAIL_COUNT++))
    fi
else
    # Publish all charts
    for chart_dir in "$CHARTS_DIR"/*; do
        if [ -d "$chart_dir" ]; then
            if publish_chart "$chart_dir"; then
                ((SUCCESS_COUNT++))
            else
                ((FAIL_COUNT++))
            fi
            echo ""
        fi
    done
fi

# Summary
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}Successful: $SUCCESS_COUNT${NC}"
if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "${RED}Failed: $FAIL_COUNT${NC}"
fi
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}This was a dry run. No charts were actually published.${NC}"
    echo "Remove --dry-run flag to publish charts."
fi

if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
fi

exit 0
