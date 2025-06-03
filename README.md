# TF141 Helm Charts

A collection of Helm charts for media server applications and automation tools.

## Usage

```bash
helm repo add tf141 https://tf141.github.io/helmcharts
helm repo update
```

## Available Charts

| Chart | Description |
|-------|-------------|
| autopulse | Automation tool for media management |
| autoscan | Real-time file system monitoring for media servers |
| huntarr | Media content management tool |
| jellyseerr | Request management for Jellyfin |
| lidarr | Music collection manager for Usenet and BitTorrent users |
| overseerr | Request management for Plex |
| prowlarr | Indexer manager/proxy for PVR apps |
| qbittorrent | BitTorrent client |
| radarr | Movie collection manager for Usenet and BitTorrent users |
| sabnzbd | Binary newsreader with web-UI |
| sonarr | TV show collection manager for Usenet and BitTorrent users |
| tautulli | Monitoring and tracking tool for Plex |

## Installation

To install a chart from this repository:

```bash
helm install my-release tf141/<chart-name>
```

For example:

```bash
helm install my-sonarr tf141/sonarr
```

## Configuration

Each chart has its own set of configurable values. To see the default values for a chart:

```bash
helm show values tf141/<chart-name>
```

You can override these values by creating your own values file:

```bash
helm install my-release tf141/<chart-name> -f my-values.yaml
```

## Documentation

For more detailed information about each chart, please refer to the README in each chart's directory.
