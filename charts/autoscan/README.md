# Autoscan Helm Chart

This chart deploys [autoscan](https://github.com/Cloudbox/autoscan).

*   **Chart Name:** autoscan
*   **Chart Version:** 0.1.8
*   **App Version:** 1.0.0
*   **Description:** A Helm chart to deploy autoscan

## Configuration

The following table lists the configurable parameters of the Autoscan chart and their default values.

| Parameter                       | Description                                                                 | Default                                    |
| ------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                  | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`              | String to override the full release name                                    | `""`                                       |
| `namespace`                     | Namespace to deploy the chart into                                          | `default`                                  |
| `image.repository`              | Image repository                                                            | `cloudb0x/autoscan`                        |
| `image.tag`                     | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`              | Image pull policy                                                           | `IfNotPresent`                             |
| `labels`                        | Additional labels to add to resources                                       | `{}`                                       |
| `replicaCount`                  | Number of replicas                                                          | `1`                                        |
| `resources.limits.cpu`          | CPU limit                                                                   | `50m`                                      |
| `resources.limits.memory`       | Memory limit                                                                | `128Mi`                                    |
| `resources.requests.cpu`        | CPU request                                                                 | `10m`                                      |
| `resources.requests.memory`     | Memory request                                                              | `64Mi`                                     |
| `nodeSelector`                  | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                   | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                      | Affinity rules for pod assignment                                           | `{}`                                       |
| `config.existingSecret`         | Name of an existing secret to use for `config.yml` (skips creation)         | `""`                                       |
| `config.minimumAge`             | Minimum age for a file/folder to be scanned                                 | `5m`                                       |
| `config.scanDelay`              | Delay between scans                                                         | `30s`                                      |
| `config.port`                   | Port for the Autoscan service                                               | `3030`                                     |
| `config.triggers.lidarr.enabled`| Enable Lidarr trigger                                                       | `true`                                     |
| `config.triggers.lidarr.priority`| Priority for Lidarr trigger                                                 | `1`                                        |
| `config.triggers.radarr.enabled`| Enable Radarr trigger                                                       | `true`                                     |
| `config.triggers.radarr.priority`| Priority for Radarr trigger                                                 | `2`                                        |
| `config.triggers.sonarr.enabled`| Enable Sonarr trigger                                                       | `true`                                     |
| `config.triggers.sonarr.priority`| Priority for Sonarr trigger                                                 | `2`                                        |
| `config.targets.plex.url`       | URL of the Plex server                                                      | `""`                                       |
| `config.targets.plex.token`     | Plex token (if `useTokenSecret` is false)                                   | `""`                                       |
| `config.targets.plex.useTokenSecret` | Use a Kubernetes secret for the Plex token                              | `false`                                    |
| `config.targets.plex.tokenSecret.name` | Name of the secret containing the Plex token                          | `my-plex-token-secret`                     |
| `config.targets.plex.tokenSecret.key` | Key within the secret containing the Plex token                         | `token`                                    |
| `persistence.conf.enabled`      | Enable persistence for configuration                                        | `true`                                     |
| `persistence.conf.size`         | Size of the configuration persistent volume                                 | `500Mi`                                    |
| `persistence.conf.existingClaim`| Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.conf.storageClass` | Storage class for the configuration PVC                                     | `""`                                       |
| `persistence.database.enabled`  | Enable persistence for the database                                         | `true`                                     |
| `persistence.database.size`     | Size of the database persistent volume                                      | `500Mi`                                    |
| `persistence.database.existingClaim`| Name of an existing PVC for the database                                | `""`                                       |
| `persistence.database.storageClass` | Storage class for the database PVC                                      | `""`                                       |
| `service.type`                  | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                  | Port for the Kubernetes service                                             | `3030`                                     |

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
