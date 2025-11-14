# Azure Container Registry Integration

This repository now supports publishing Helm charts to Azure Container Registry (ACR) using the OCI format.

## 📚 Documentation

- **[Quick Start Guide](QUICKSTART_ACR.md)** - Get started in 5 minutes
- **[Full Workflow Documentation](ACR_WORKFLOW.md)** - Complete reference guide
- **[Examples](EXAMPLES.md)** - Real-world usage examples
- **[Parallel Publishing](PARALLEL_PUBLISHING.md)** - Speed up with parallel processing

## 🚀 Quick Start

```bash
# 1. Set your registry
export ACR_NAME="your-registry-name"

# 2. Authenticate
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD

# 3. Publish charts
./publish-to-acr.sh --registry $ACR_NAME

# 4. Use in Kubernetes
helm install radarr oci://$ACR_NAME.azurecr.io/helm/radarr --version 1.0.18
```

## 📦 Available Charts

All charts in the `charts/` directory can be published to ACR:

- autopulse
- autoscan
- huntarr
- jellyseerr
- lidarr
- overseerr
- prowlarr
- qbittorrent
- radarr
- sabnzbd
- sonarr
- tautulli

## 🔧 Tools

### Publishing Scripts

**Sequential (Simple):**
```bash
# Publish all charts
./publish-to-acr.sh --registry myregistry

# Publish specific chart
./publish-to-acr.sh --registry myregistry --chart radarr

# Dry run (test without pushing)
./publish-to-acr.sh --registry myregistry --dry-run
```

**Parallel (Faster for multiple charts):**
```bash
# Publish all charts with 10 parallel jobs
./publish-to-acr-parallel.sh --registry myregistry --jobs 10

# Requires: sudo apt install parallel
```

See [Parallel Publishing Guide](PARALLEL_PUBLISHING.md) for details.

### GitHub Actions

Two workflows available:

**Sequential** (`.github/workflows/publish-acr.yaml`):
- Simple, easy to debug
- Best for 1-3 charts

**Parallel** (`.github/workflows/publish-acr-parallel.yaml`):
- Up to 10 charts simultaneously
- 2-3x faster for multiple charts
- Automatic on push, manual trigger available

Both support:
- **Automatic**: Publishes changed charts on push to `main`
- **Manual**: Trigger via Actions tab
- **Smart detection**: Only publishes what changed

## 🔐 Authentication

### For Local Development

```bash
# Using Azure CLI (personal use)
PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
helm registry login $ACR_NAME.azurecr.io \
  --username 00000000-0000-0000-0000-000000000000 \
  --password $PASSWORD
```

### For CI/CD

Create a service principal and add to GitHub Secrets:

```bash
az ad sp create-for-rbac \
  --name "github-actions-helm" \
  --role "AcrPush" \
  --scopes $(az acr show --name $ACR_NAME --query id --output tsv)
```

Required GitHub Secrets:
- `ACR_NAME`: Registry name (without .azurecr.io)
- `ACR_USERNAME`: Service principal app ID
- `ACR_PASSWORD`: Service principal password

## 📖 Usage Examples

### Direct Installation

```bash
helm install radarr oci://myregistry.azurecr.io/helm/radarr \
  --version 1.0.18 \
  --namespace media \
  --create-namespace
```

### As Dependency

```yaml
# Chart.yaml
dependencies:
  - name: radarr
    version: 1.0.18
    repository: oci://myregistry.azurecr.io/helm
```

### With Argo CD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: radarr
spec:
  source:
    chart: radarr
    repoURL: oci://myregistry.azurecr.io/helm
    targetRevision: 1.0.18
  destination:
    namespace: media
```

## 🔍 Verification

```bash
# List all charts
az acr repository list --name $ACR_NAME --output table

# Show chart versions
az acr repository show-tags \
  --name $ACR_NAME \
  --repository helm/radarr \
  --output table

# View in Azure Portal
https://portal.azure.com/#view/Microsoft_Azure_ContainerRegistries/RepositoryBlade/registryName/$ACR_NAME
```

## 🆚 OCI vs Traditional Helm Repository

### OCI Format (Recommended)

✅ Native support in Helm 3.8.0+  
✅ Uses standard container registry infrastructure  
✅ Better security and access control  
✅ Integrated with Azure RBAC  
✅ No separate index.yaml management  
✅ Supports multi-architecture images  

### Traditional Helm Repository

⚠️ Requires separate HTTP server  
⚠️ Manual index.yaml management  
⚠️ Additional infrastructure overhead  
⚠️ Less granular access control  

## 🔄 Migration

### From GitHub Container Registry (GHCR)

```bash
# Pull from GHCR
helm pull oci://ghcr.io/user/chart --version 1.0.0

# Push to ACR
helm push chart-1.0.0.tgz oci://myregistry.azurecr.io/helm

# Update Chart.yaml dependencies
# Change: repository: oci://ghcr.io/user
# To:     repository: oci://myregistry.azurecr.io/helm
```

### From Traditional Helm Repository

```bash
# Add old repo
helm repo add oldrepo https://charts.example.com

# Pull chart
helm pull oldrepo/chart --version 1.0.0

# Push to ACR
helm push chart-1.0.0.tgz oci://myregistry.azurecr.io/helm
```

## 🛠️ Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
helm registry logout $ACR_NAME.azurecr.io
PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
helm registry login $ACR_NAME.azurecr.io \
  --username 00000000-0000-0000-0000-000000000000 \
  --password $PASSWORD
```

### Chart Name Issues

Chart names must be lowercase with hyphens only:
- ✅ `my-chart`
- ❌ `MyChart`
- ❌ `my_chart`

### Version Not Found

Ensure the chart version exists:
```bash
az acr repository show-tags \
  --name $ACR_NAME \
  --repository helm/radarr \
  --output table
```

## 📊 Best Practices

1. **Versioning**: Use semantic versioning (e.g., 1.0.0, 1.0.1)
2. **Namespaces**: Organize charts with namespaces (e.g., `helm/`, `apps/`)
3. **Testing**: Always test locally before publishing
4. **Documentation**: Keep Chart.yaml metadata up to date
5. **Cleanup**: Regularly remove old/unused versions
6. **Security**: Use service principals for CI/CD, not personal credentials
7. **Monitoring**: Track ACR usage in Azure Portal

## 🔗 Resources

- [Azure Container Registry Documentation](https://learn.microsoft.com/en-us/azure/container-registry/)
- [Helm OCI Support](https://helm.sh/docs/topics/registries/)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/acr)
- [Argo CD Helm Charts](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/)

## 💡 Tips

- **Token Expiry**: Azure CLI tokens expire after a few hours. Re-authenticate if you get auth errors.
- **Parallel Publishing**: The script publishes charts sequentially. For faster publishing, consider parallel execution.
- **Storage Costs**: ACR charges for storage. Clean up old versions to reduce costs.
- **Bandwidth**: ACR includes bandwidth in pricing. Monitor usage for cost optimization.
- **Geo-Replication**: Use ACR geo-replication for multi-region deployments.

## 🤝 Contributing

When adding new charts:

1. Create chart in `charts/` directory
2. Ensure Chart.yaml has correct version
3. Test locally: `helm template charts/mychart --debug`
4. Commit and push to trigger automatic publishing
5. Verify in ACR: `az acr repository show --name $ACR_NAME --repository helm/mychart`

## 📝 License

Same as the main repository.
