# Helm Charts Collection

This repository contains a collection of Helm charts for deploying various applications in Kubernetes. These charts are designed to be easy to use and customizable for different environments.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Available Charts](#available-charts)
  - [Media Management](#media-management)
  - [Monitoring](#monitoring)
  - [Database](#database)
- [Usage](#usage)
- [Configuration](#configuration)
- [Renovate Integration](#renovate-integration)

## Overview

This Helm chart repository provides a collection of charts for deploying various applications in Kubernetes environments. The charts follow best practices for Kubernetes deployments and include sensible defaults while allowing for customization through values files.

## Installation

To use these Helm charts, add this repository to your Helm configuration:

```bash
helm repo add tf141 https://tomf141.github.io/helmcharts/
helm repo update
```

## Available Charts

### Media Management

| Chart | Description | Version |
|-------|-------------|---------|
| [autoscan](./charts/autoscan/) | A Helm chart to deploy autoscan | 0.1.8 |
| [huntarr](./charts/huntarr/) | A Helm chart for Huntarr (4sonarr) | 0.1.0 |
| [overseerr](./charts/overseerr/) | A Helm chart to deploy Overseerr - a request management and media discovery tool for the Plex ecosystem | 0.1.0 |
| [prowlarr](./charts/prowlarr/) | A Helm chart to deploy Prowlarr | 0.1.2 |
| [qbittorrent](./charts/qbittorrent/) | A Helm chart to deploy qBittorrent | 0.1.0 |
| [radarr](./charts/radarr/) | A Helm chart to deploy Radarr | 0.1.4 |
| [sabnzbd](./charts/sabnzbd/) | A Helm chart for Sabnzbd Usenet downloader | 0.1.1 |
| [sonarr](./charts/sonarr/) | A Helm chart to deploy Sonarr | 0.1.6 |

### Monitoring

| Chart | Description | Version |
|-------|-------------|---------|
| [tautulli](./charts/tautulli/) | A Helm chart to deploy Tautulli - a monitoring and tracking tool for Plex Media Server | 0.1.6 |

## Usage

To install a chart from this repository:

```bash
# Install with default values
helm install my-release tf141/<chart-name>

# Install with custom values
helm install my-release tf141/<chart-name> -f my-values.yaml
```

For example, to install Tautulli:

```bash
helm install tautulli tf141/tautulli
```

## Configuration

Each chart includes a `values.yaml` file with default configuration options. You can customize these values by creating your own values file and passing it to the `helm install` command.

Common configuration options include:

- **Image settings**: Repository, tag, and pull policy
- **Replica count**: Number of pod replicas
- **Environment variables**: Application-specific environment variables
- **Service configuration**: Service type and port
- **Resource requests and limits**: CPU and memory allocation
- **Persistence**: Storage configuration for stateful applications
- **Security context**: Pod and container security settings
- **Node scheduling**: Node selectors, tolerations, and affinity rules

Example custom values file for Tautulli:

```yaml
image:
  tag: latest

replicaCount: 1

env:
  PUID: "1000"
  PGID: "1000"
  TZ: "Europe/London"

persistence:
  config:
    enabled: true
    size: 2Gi
    storageClass: "standard"

resources:
  limits:
    memory: 1Gi
  requests:
    cpu: 100m
    memory: 512Mi
```

## Renovate Integration

This repository is integrated with Renovate for automated dependency updates. Renovate monitors:

- Helm chart versions
- Container image versions
- Chart dependencies

The configuration is defined in `renovate.json` at the root of the repository.

## Chart Structure

Each chart follows the standard Helm chart structure:

```
charts/<chart-name>/
├── Chart.yaml           # Chart metadata
├── values.yaml          # Default configuration values
├── templates/           # Kubernetes manifest templates
│   ├── _helpers.tpl     # Template helpers
│   ├── deployment.yaml  # Deployment configuration
│   ├── service.yaml     # Service configuration
│   └── ...              # Other resources
└── README.md            # Chart documentation
```

## Deployment with ArgoCD

These charts are designed to work seamlessly with ArgoCD for GitOps-based deployments. For more information on using these charts with ArgoCD, refer to the [ArgoCD documentation](../argocd/README.md).
