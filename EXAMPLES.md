# Azure Container Registry Helm Chart Examples

## Example 1: Publishing Your Charts

### Single Chart

```bash
# Navigate to helmcharts directory
cd /home/tom/vscode/helmcharts

# Set your ACR name
export ACR_NAME="myregistry"

# Publish radarr chart
./publish-to-acr.sh --registry $ACR_NAME --chart radarr

# Output:
# Processing: radarr
#   Version: 1.0.18
#   Packaging...
#   Pushing to ACR...
#   ✓ Successfully published radarr:1.0.18
```

### All Charts

```bash
# Publish all 12 charts at once
./publish-to-acr.sh --registry $ACR_NAME

# This will publish:
# - autopulse
# - autoscan
# - huntarr
# - jellyseerr
# - lidarr
# - overseerr
# - prowlarr
# - qbittorrent
# - radarr
# - sabnzbd
# - sonarr
# - tautulli
```

## Example 2: Using Charts in Kubernetes

### Direct Installation

```bash
# Install radarr from ACR
helm install radarr oci://myregistry.azurecr.io/helm/radarr \
  --version 1.0.18 \
  --namespace media \
  --create-namespace

# Install with custom values
helm install radarr oci://myregistry.azurecr.io/helm/radarr \
  --version 1.0.18 \
  --namespace media \
  --values /home/tom/vscode/kubernetes-production/apps/radarr/values.yaml
```

### Upgrade Existing Installation

```bash
# Upgrade to newer version
helm upgrade radarr oci://myregistry.azurecr.io/helm/radarr \
  --version 1.0.19 \
  --namespace media
```

## Example 3: Using as Dependencies

### Create a Media Stack Chart

Create a new chart that bundles multiple media apps:

**Chart.yaml**
```yaml
apiVersion: v2
name: media-stack
description: Complete media server stack
type: application
version: 1.0.0

dependencies:
  - name: radarr
    version: 1.0.18
    repository: oci://myregistry.azurecr.io/helm
    condition: radarr.enabled
  
  - name: sonarr
    version: 1.0.18
    repository: oci://myregistry.azurecr.io/helm
    condition: sonarr.enabled
  
  - name: prowlarr
    version: 1.0.18
    repository: oci://myregistry.azurecr.io/helm
    condition: prowlarr.enabled
  
  - name: qbittorrent
    version: 1.0.18
    repository: oci://myregistry.azurecr.io/helm
    condition: qbittorrent.enabled
  
  - name: jellyseerr
    version: 1.0.18
    repository: oci://myregistry.azurecr.io/helm
    condition: jellyseerr.enabled
```

**values.yaml**
```yaml
# Enable/disable components
radarr:
  enabled: true
  
sonarr:
  enabled: true
  
prowlarr:
  enabled: true
  
qbittorrent:
  enabled: true
  
jellyseerr:
  enabled: true
```

**Deploy the stack:**
```bash
# Update dependencies
helm dependency update

# Install the complete stack
helm install media-stack . --namespace media --create-namespace
```

## Example 4: Argo CD Application

### Using ACR Charts with Argo CD

**application.yaml**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: radarr
  namespace: argocd
spec:
  project: default
  
  source:
    chart: radarr
    repoURL: oci://myregistry.azurecr.io/helm
    targetRevision: 1.0.18
    helm:
      valueFiles:
        - values.yaml
      values: |
        image:
          repository: lscr.io/linuxserver/radarr
          tag: latest
        
        persistence:
          enabled: true
          storageClass: longhorn
          size: 10Gi
  
  destination:
    server: https://kubernetes.default.svc
    namespace: media
  
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### Argo CD with External Values

**application.yaml**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: radarr
  namespace: argocd
spec:
  project: default
  
  sources:
    # Helm chart from ACR
    - chart: radarr
      repoURL: oci://myregistry.azurecr.io/helm
      targetRevision: 1.0.18
      helm:
        valueFiles:
          - $values/apps/radarr/values.yaml
    
    # Values from Git repo
    - repoURL: https://github.com/TOMF141/kubernetes-production.git
      targetRevision: main
      ref: values
  
  destination:
    server: https://kubernetes.default.svc
    namespace: media
  
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Example 5: Updating Your Current sftpgo Setup

Your current setup in `/home/tom/vscode/kubernetes-production/apps/sftpgo/application/Chart.yaml`:

**Before (using GHCR):**
```yaml
apiVersion: v2
name: sftpgo
version: 1.0.0
dependencies:
- name: sftpgo
  version: 0.38.0
  repository: oci://ghcr.io/sftpgo/helm-charts
```

**After (using ACR):**

If you want to mirror the sftpgo chart to ACR:

```bash
# Pull from GHCR
helm pull oci://ghcr.io/sftpgo/helm-charts/sftpgo --version 0.38.0

# Login to ACR
helm registry login myregistry.azurecr.io --username $USER --password $PASS

# Push to ACR
helm push sftpgo-0.38.0.tgz oci://myregistry.azurecr.io/helm

# Update Chart.yaml
```

```yaml
apiVersion: v2
name: sftpgo
version: 1.0.0
dependencies:
- name: sftpgo
  version: 0.38.0
  repository: oci://myregistry.azurecr.io/helm
```

## Example 6: CI/CD with GitHub Actions

### Automatic Publishing on Push

When you push changes to any chart:

```bash
# Make changes to radarr chart
cd /home/tom/vscode/helmcharts/charts/radarr
vim Chart.yaml  # Bump version to 1.0.19

# Commit and push
git add Chart.yaml
git commit -m "chore(radarr): bump version to 1.0.19"
git push origin main

# GitHub Actions automatically:
# 1. Detects changed chart (radarr)
# 2. Packages the chart
# 3. Pushes to ACR
# 4. Creates summary in Actions tab
```

### Manual Workflow Trigger

```bash
# Trigger via GitHub CLI
gh workflow run publish-acr.yaml \
  --field chart_name=radarr \
  --field dry_run=false

# Or via GitHub web UI:
# 1. Go to Actions tab
# 2. Select "Publish Helm Charts to ACR"
# 3. Click "Run workflow"
# 4. Enter chart name (or leave empty for all)
# 5. Choose dry run option
# 6. Click "Run workflow"
```

## Example 7: Authentication Methods

### Personal Use (Azure CLI)

```bash
# Login to Azure
az login

# Get token and login to Helm
export ACR_NAME="myregistry"
export PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)

helm registry login $ACR_NAME.azurecr.io \
  --username 00000000-0000-0000-0000-000000000000 \
  --password $PASSWORD
```

### CI/CD (Service Principal)

```bash
# Create service principal (one-time setup)
az ad sp create-for-rbac \
  --name "github-actions-helm" \
  --role "AcrPush" \
  --scopes $(az acr show --name $ACR_NAME --query id --output tsv)

# Output:
# {
#   "appId": "12345678-1234-1234-1234-123456789abc",
#   "password": "super-secret-password",
#   "tenant": "87654321-4321-4321-4321-cba987654321"
# }

# Add to GitHub Secrets:
# ACR_NAME: myregistry
# ACR_USERNAME: 12345678-1234-1234-1234-123456789abc
# ACR_PASSWORD: super-secret-password
```

### Repository-Scoped Token

```bash
# Create token with limited permissions
az acr token create \
  --name helm-publisher \
  --registry $ACR_NAME \
  --scope-map _repositories_admin \
  --query "credentials.passwords[0].value" \
  --output tsv

# Use the token
helm registry login $ACR_NAME.azurecr.io \
  --username helm-publisher \
  --password <token-from-above>
```

## Example 8: Verification

### Check Published Charts

```bash
# List all repositories
az acr repository list --name $ACR_NAME --output table

# Expected output:
# Result
# ----------------
# helm/autopulse
# helm/autoscan
# helm/huntarr
# helm/jellyseerr
# helm/lidarr
# helm/overseerr
# helm/prowlarr
# helm/qbittorrent
# helm/radarr
# helm/sabnzbd
# helm/sonarr
# helm/tautulli

# Show chart details
az acr repository show \
  --name $ACR_NAME \
  --repository helm/radarr

# List versions
az acr repository show-tags \
  --name $ACR_NAME \
  --repository helm/radarr \
  --output table
```

### Test Installation

```bash
# Create test namespace
kubectl create namespace test-media

# Install chart
helm install test-radarr oci://$ACR_NAME.azurecr.io/helm/radarr \
  --version 1.0.18 \
  --namespace test-media

# Check status
helm status test-radarr --namespace test-media

# Cleanup
helm uninstall test-radarr --namespace test-media
kubectl delete namespace test-media
```

## Example 9: Bulk Migration Script

If you want to migrate all your charts from another registry to ACR:

```bash
#!/bin/bash
# migrate-to-acr.sh

SOURCE_REGISTRY="ghcr.io/myuser"
TARGET_REGISTRY="myregistry.azurecr.io/helm"

CHARTS=(
  "radarr:1.0.18"
  "sonarr:1.0.18"
  "prowlarr:1.0.18"
)

for chart in "${CHARTS[@]}"; do
  name="${chart%:*}"
  version="${chart#*:}"
  
  echo "Migrating $name:$version..."
  
  # Pull from source
  helm pull oci://$SOURCE_REGISTRY/$name --version $version
  
  # Push to ACR
  helm push ${name}-${version}.tgz oci://$TARGET_REGISTRY
  
  # Cleanup
  rm ${name}-${version}.tgz
  
  echo "✓ Migrated $name:$version"
done
```

## Example 10: Local Development Workflow

```bash
# 1. Make changes to chart
cd /home/tom/vscode/helmcharts/charts/radarr
vim templates/deployment.yaml

# 2. Update version in Chart.yaml
vim Chart.yaml  # Bump version

# 3. Test locally
helm template . --debug

# 4. Test installation in local cluster
helm install test-radarr . --dry-run --debug

# 5. Package and push to ACR
cd ../..
./publish-to-acr.sh --registry $ACR_NAME --chart radarr

# 6. Test from ACR
helm install test-radarr oci://$ACR_NAME.azurecr.io/helm/radarr \
  --version 1.0.19 \
  --namespace test

# 7. Cleanup
helm uninstall test-radarr --namespace test
```

## Tips

1. **Always bump version** in Chart.yaml before publishing
2. **Test locally first** with `helm template` and `--dry-run`
3. **Use semantic versioning** (major.minor.patch)
4. **Document changes** in chart README or CHANGELOG
5. **Keep ACR organized** with consistent namespaces
6. **Clean up old versions** periodically to save storage costs
7. **Use Argo CD** for GitOps-style deployments
8. **Monitor ACR usage** in Azure Portal for storage and bandwidth
