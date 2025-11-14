# Quick Start: Azure Container Registry for Helm Charts

## TL;DR

```bash
# 1. Set your registry name
export ACR_NAME="your-registry-name"

# 2. Login to ACR
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD

# 3. Publish all charts
./publish-to-acr.sh --registry $ACR_NAME

# 4. Use in your deployments
helm install my-app oci://$ACR_NAME.azurecr.io/helm/radarr --version 1.0.0
```

## One-Time Setup

### 1. Authenticate to Azure

```bash
# Login to Azure
az login

# Set your ACR name (without .azurecr.io)
export ACR_NAME="myregistry"
```

### 2. Get ACR Credentials

**Option A: Personal Use (Azure CLI Token)**
```bash
USER_NAME="00000000-0000-0000-0000-000000000000"
PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
```

**Option B: CI/CD (Service Principal)**
```bash
# Create service principal
az ad sp create-for-rbac \
  --name "acr-helm-publisher" \
  --role "AcrPush" \
  --scopes $(az acr show --name $ACR_NAME --query id --output tsv)

# Save the output - you'll need appId and password
```

### 3. Login to Helm Registry

```bash
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD
```

## Publishing Charts

### Publish All Charts

```bash
./publish-to-acr.sh --registry $ACR_NAME
```

### Publish Specific Chart

```bash
./publish-to-acr.sh --registry $ACR_NAME --chart radarr
```

### Dry Run (Test Without Publishing)

```bash
./publish-to-acr.sh --registry $ACR_NAME --dry-run
```

### Custom Namespace

```bash
./publish-to-acr.sh --registry $ACR_NAME --namespace apps
```

## Using Published Charts

### Install Chart

```bash
# Install specific version
helm install radarr oci://$ACR_NAME.azurecr.io/helm/radarr --version 1.0.0

# Install latest version
helm install radarr oci://$ACR_NAME.azurecr.io/helm/radarr

# With custom values
helm install radarr oci://$ACR_NAME.azurecr.io/helm/radarr \
  --version 1.0.0 \
  --values my-values.yaml
```

### Use as Dependency

In your `Chart.yaml`:

```yaml
apiVersion: v2
name: my-application
version: 1.0.0
dependencies:
  - name: radarr
    version: 1.0.0
    repository: oci://myregistry.azurecr.io/helm
  - name: sonarr
    version: 1.0.0
    repository: oci://myregistry.azurecr.io/helm
```

Then run:

```bash
helm dependency update
helm install my-app .
```

## GitHub Actions Setup

### Required Secrets

Add these secrets to your GitHub repository:

1. **ACR_NAME**: Your registry name (e.g., `myregistry`)
2. **ACR_USERNAME**: Service principal app ID or token username
3. **ACR_PASSWORD**: Service principal password or token

### Manual Trigger

1. Go to **Actions** tab in GitHub
2. Select **Publish Helm Charts to ACR**
3. Click **Run workflow**
4. Choose options:
   - Leave chart name empty to publish all
   - Enter specific chart name to publish one
   - Enable dry run to test without pushing

### Automatic Publishing

Charts are automatically published when:
- You push changes to `charts/**` on the `main` branch
- Only changed charts are published

## Verification

### List Charts in ACR

```bash
# Using Azure CLI
az acr repository list --name $ACR_NAME --output table

# Show specific chart
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

### View in Azure Portal

```
https://portal.azure.com/#view/Microsoft_Azure_ContainerRegistries/RepositoryBlade/registryName/YOUR_REGISTRY_NAME
```

## Common Commands

```bash
# Check Helm version (need 3.8.0+)
helm version

# Test authentication
helm registry login $ACR_NAME.azurecr.io --username $USER_NAME --password $PASSWORD

# Pull chart locally
helm pull oci://$ACR_NAME.azurecr.io/helm/radarr --version 1.0.0

# Uninstall chart
helm uninstall radarr

# Delete chart from ACR
az acr repository delete \
  --name $ACR_NAME \
  --image helm/radarr:1.0.0 \
  --yes
```

## Troubleshooting

### "unauthorized: authentication required"

Re-authenticate:
```bash
helm registry logout $ACR_NAME.azurecr.io
helm registry login $ACR_NAME.azurecr.io --username $USER_NAME --password $PASSWORD
```

### "Error: failed to authorize: failed to fetch anonymous token"

Your token may have expired. Get a new one:
```bash
PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
helm registry login $ACR_NAME.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password $PASSWORD
```

### "chart name must be lowercase"

Chart names in ACR must be lowercase with hyphens only. Update your `Chart.yaml`:
```yaml
name: my-chart  # Good
name: MyChart   # Bad
name: my_chart  # Bad
```

## Migration from Other Registries

If you're currently using GitHub Container Registry (GHCR) or another OCI registry:

```bash
# Pull from old registry
helm pull oci://ghcr.io/user/chart --version 1.0.0

# Push to ACR
helm push chart-1.0.0.tgz oci://$ACR_NAME.azurecr.io/helm

# Update Chart.yaml dependencies
# Change: repository: oci://ghcr.io/user
# To:     repository: oci://myregistry.azurecr.io/helm
```

## Best Practices

1. **Use semantic versioning** in Chart.yaml (e.g., 1.0.0, 1.0.1)
2. **Organize with namespaces** (e.g., `helm/`, `apps/`, `infrastructure/`)
3. **Use service principals** for CI/CD, not personal credentials
4. **Test locally** before pushing to ACR
5. **Tag releases** in Git to match chart versions
6. **Document breaking changes** in chart README files
7. **Clean up old versions** periodically to save storage

## Resources

- Full documentation: [ACR_WORKFLOW.md](./ACR_WORKFLOW.md)
- Publishing script: [publish-to-acr.sh](./publish-to-acr.sh)
- GitHub Actions: [.github/workflows/publish-acr.yaml](.github/workflows/publish-acr.yaml)
- Azure ACR Docs: https://learn.microsoft.com/en-us/azure/container-registry/
- Helm OCI Support: https://helm.sh/docs/topics/registries/
