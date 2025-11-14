# Azure Container Registry (ACR) Helm Chart Workflow

## Prerequisites

- **Helm**: Version 3.8.0 or later (OCI support enabled by default)
- **Azure CLI**: Version 2.0.71 or later
- **Azure Container Registry**: An ACR instance in your Azure subscription
- **Permissions**: Push/pull access to ACR (AcrPush role or equivalent)

Check your Helm version:
```bash
helm version
```

## Initial Setup

### 1. Set Environment Variables

```bash
# Set your ACR name (without .azurecr.io)
export ACR_NAME="your-registry-name"

# Verify
echo $ACR_NAME.azurecr.io
```

### 2. Authenticate to ACR

#### Option A: Using Azure CLI (Individual Identity)
```bash
# Get access token
USER_NAME="00000000-0000-0000-0000-000000000000"
PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)

# Login to Helm registry
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD
```

#### Option B: Using Service Principal (CI/CD)
```bash
# Create service principal with push permissions
SERVICE_PRINCIPAL_NAME="acr-helm-sp"
PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME \
  --scopes $(az acr show --name $ACR_NAME --query id --output tsv) \
  --role "AcrPush" \
  --query "password" --output tsv)

USER_NAME=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Login to Helm registry
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD
```

#### Option C: Using Repository-Scoped Token
```bash
# Create token with admin access to all repositories
USER_NAME="helmtoken"
PASSWORD=$(az acr token create -n $USER_NAME \
  -r $ACR_NAME \
  --scope-map _repositories_admin \
  --only-show-errors \
  --query "credentials.passwords[0].value" -o tsv)

# Login to Helm registry
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD
```

## Publishing Charts

### 1. Package Your Chart

Navigate to your chart directory and package it:

```bash
cd /home/tom/vscode/helmcharts/charts/radarr
helm package .
```

This creates a `.tgz` file like `radarr-1.0.0.tgz`.

### 2. Push to ACR

Push the packaged chart to ACR as an OCI artifact:

```bash
# Push to a specific namespace (e.g., helm/)
helm push radarr-1.0.0.tgz oci://$ACR_NAME.azurecr.io/helm

# Or push to root
helm push radarr-1.0.0.tgz oci://$ACR_NAME.azurecr.io
```

**Important Notes:**
- Chart names must use lowercase letters and numbers only
- Separate words with hyphens (e.g., `hello-world`)
- The namespace (e.g., `helm/`) is optional but recommended for organization

### 3. Verify Upload

```bash
# List repositories
az acr repository list --name $ACR_NAME --output table

# Show specific chart
az acr repository show \
  --name $ACR_NAME \
  --repository helm/radarr

# List chart versions/tags
az acr manifest list-metadata \
  --registry $ACR_NAME \
  --name helm/radarr
```

## Consuming Charts

### 1. Install Chart from ACR

```bash
# Install with specific version
helm install my-radarr oci://$ACR_NAME.azurecr.io/helm/radarr --version 1.0.0

# Install latest version
helm install my-radarr oci://$ACR_NAME.azurecr.io/helm/radarr

# Install with custom values
helm install my-radarr oci://$ACR_NAME.azurecr.io/helm/radarr \
  --version 1.0.0 \
  --values custom-values.yaml
```

### 2. Use as Dependency in Chart.yaml

Update your `Chart.yaml` to reference ACR:

```yaml
apiVersion: v2
name: my-app
version: 1.0.0
dependencies:
  - name: radarr
    version: 1.0.0
    repository: oci://your-registry.azurecr.io/helm
```

Then update dependencies:

```bash
helm dependency update
```

### 3. Pull Chart to Local Archive

```bash
# Pull specific version
helm pull oci://$ACR_NAME.azurecr.io/helm/radarr --version 1.0.0

# This downloads radarr-1.0.0.tgz to current directory
```

## Bulk Operations

### Publish All Charts

Create a script to publish all charts in your collection:

```bash
#!/bin/bash
# publish-all-charts.sh

ACR_NAME="your-registry-name"
CHARTS_DIR="/home/tom/vscode/helmcharts/charts"

for chart_dir in $CHARTS_DIR/*/; do
  chart_name=$(basename "$chart_dir")
  echo "Processing $chart_name..."
  
  cd "$chart_dir"
  
  # Package chart
  helm package .
  
  # Find the generated .tgz file
  tgz_file=$(ls -t ${chart_name}-*.tgz 2>/dev/null | head -1)
  
  if [ -n "$tgz_file" ]; then
    echo "Pushing $tgz_file to ACR..."
    helm push "$tgz_file" oci://$ACR_NAME.azurecr.io/helm
    
    # Clean up
    rm "$tgz_file"
    echo "✓ Published $chart_name"
  else
    echo "✗ Failed to package $chart_name"
  fi
  
  echo ""
done

echo "All charts processed!"
```

Make it executable and run:

```bash
chmod +x publish-all-charts.sh
./publish-all-charts.sh
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Publish Helm Charts

on:
  push:
    branches: [main]
    paths:
      - 'charts/**'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Helm
        uses: azure/setup-helm@v3
        with:
          version: 'latest'
      
      - name: Login to ACR
        run: |
          helm registry login ${{ secrets.ACR_NAME }}.azurecr.io \
            --username ${{ secrets.ACR_USERNAME }} \
            --password ${{ secrets.ACR_PASSWORD }}
      
      - name: Package and Push Charts
        run: |
          for chart in charts/*/; do
            cd "$chart"
            helm package .
            helm push *.tgz oci://${{ secrets.ACR_NAME }}.azurecr.io/helm
            cd ../..
          done
```

## Management Commands

### List All Charts in ACR

```bash
az acr repository list --name $ACR_NAME --output table
```

### Show Chart Details

```bash
az acr repository show \
  --name $ACR_NAME \
  --repository helm/radarr
```

### List Chart Versions

```bash
az acr repository show-tags \
  --name $ACR_NAME \
  --repository helm/radarr \
  --output table
```

### Delete a Chart Version

```bash
az acr repository delete \
  --name $ACR_NAME \
  --image helm/radarr:1.0.0 \
  --yes
```

### Delete Entire Chart Repository

```bash
az acr repository delete \
  --name $ACR_NAME \
  --repository helm/radarr \
  --yes
```

## Best Practices

1. **Versioning**: Use semantic versioning (e.g., 1.0.0, 1.0.1) in Chart.yaml
2. **Namespaces**: Organize charts in namespaces (e.g., `helm/`, `apps/`)
3. **Authentication**: Use service principals or managed identities for CI/CD
4. **Naming**: Use lowercase and hyphens only in chart names
5. **Testing**: Test charts locally before pushing to ACR
6. **Documentation**: Keep Chart.yaml metadata up to date
7. **Cleanup**: Regularly remove old/unused chart versions

## Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
helm registry logout $ACR_NAME.azurecr.io
helm registry login $ACR_NAME.azurecr.io --username $USER_NAME --password $PASSWORD
```

### Check Helm OCI Support

```bash
helm version
# Should show version 3.8.0 or later
```

### Verify ACR Permissions

```bash
az acr check-health --name $ACR_NAME --yes
```

### Debug Push Issues

```bash
# Enable verbose output
helm push chart.tgz oci://$ACR_NAME.azurecr.io/helm --debug
```

## Migration from Other Registries

If migrating from GitHub Container Registry (GHCR) or other OCI registries:

1. Pull existing charts:
   ```bash
   helm pull oci://ghcr.io/user/chart --version 1.0.0
   ```

2. Push to ACR:
   ```bash
   helm push chart-1.0.0.tgz oci://$ACR_NAME.azurecr.io/helm
   ```

3. Update Chart.yaml dependencies to point to ACR

## Additional Resources

- [Azure Container Registry Documentation](https://learn.microsoft.com/en-us/azure/container-registry/)
- [Helm OCI Support](https://helm.sh/docs/topics/registries/)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/acr)
