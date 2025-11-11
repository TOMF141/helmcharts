# qBittorrent Helm Chart

This chart deploys [qBittorrent](https://www.qbittorrent.org/).

*   **Chart Name:** qbittorrent
*   **Chart Version:** 0.1.0
*   **App Version:** latest
*   **Description:** A Helm chart to deploy qBittorrent

## Configuration

The following table lists the configurable parameters of the qBittorrent chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `download`                                 |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/qbittorrent`          |
| `image.tag`                           | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`                    | Image pull policy                                                           | `Always`                                   |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `labels`                              | Additional labels to add to resources                                       | (See `values.yaml`)                        |
| `env.UMASK`                           | Umask setting for the container                                             | `"000"`                                    |
| `env.DOCKER_MODS`                     | Docker Mods for theme installation (e.g., Theme Park)                       | `ghcr.io/themepark-dev/theme.park:qbittorrent` |
| `env.TP_THEME`                        | Theme Park theme name                                                       | `plex`                                     |
| `livenessProbe.enabled`               | Enable liveness probe                                                       | `true`                                     |
| `livenessProbe.initialDelaySeconds`   | Initial delay for liveness probe                                            | `30`                                       |
| `livenessProbe.periodSeconds`         | Period for liveness probe checks                                            | `60`                                       |
| `livenessProbe.command`               | Command for liveness probe check                                            | `curl --fail localhost:8080`               |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `8080`                                     |
| `resources.limits.cpu`                | CPU limit                                                                   | `"2"`                                      |
| `resources.limits.memory`             | Memory limit                                                                | `4Gi`                                      |
| `resources.requests.cpu`              | CPU request                                                                 | `"1"`                                      |
| `resources.requests.memory`           | Memory request                                                              | `2Gi`                                      |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `persistence.config.enabled`          | Enable persistence for the `/config` directory                              | `true`                                     |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `qbittorrent-config`                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `persistence.download.enabled`        | Enable persistence for the download directory                               | `true`                                     |
| `persistence.download.size`           | Size of the download persistent volume                                      | `1000Gi`                                   |
| `persistence.download.existingClaim`  | Name of an existing PVC for downloads                                       | `qbittorrent-download`                     |
| `persistence.download.storageClass`   | Storage class for the download PVC                                          | `""`                                       |
| `nfs.enabled`                         | Enable NFS volume mount for media                                           | `true`                                     |
| `nfs.server`                          | NFS server address                                                          | `"10.3.201.151"`                           |
| `nfs.path`                            | Path on the NFS server                                                      | `"/mnt/zpool/plexmedia"`                   |
| `hostname`                            | Hostname for the pod                                                        | `qbittorrent`                              |

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
