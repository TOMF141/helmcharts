# Overseerr Helm Chart

This chart deploys [Overseerr](https://overseerr.dev/).

*   **Chart Name:** overseerr
*   **Chart Version:** 0.1.0
*   **App Version:** latest
*   **Description:** A Helm chart to deploy Overseerr - a request management and media discovery tool for the Plex ecosystem

## Configuration

The following table lists the configurable parameters of the Overseerr chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `webapps`                                  |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/overseerr`            |
| `image.tag`                           | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`                    | Image pull policy                                                           | `Always`                                   |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `labels`                              | Additional labels to add to resources                                       | `{}`                                       |
| `env.TZ`                              | Timezone for the container                                                  | `Europe/London`                            |
| `livenessProbe.enabled`               | Enable liveness probe                                                       | `true`                                     |
| `livenessProbe.initialDelaySeconds`   | Initial delay for liveness probe                                            | `30`                                       |
| `livenessProbe.periodSeconds`         | Period for liveness probe checks                                            | `60`                                       |
| `livenessProbe.command`               | Command for liveness probe check                                            | `curl --fail localhost:5055`               |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `5055`                                     |
| `resources.limits.memory`             | Memory limit                                                                | `512Mi`                                    |
| `resources.requests.cpu`              | CPU request                                                                 | `500m`                                     |
| `resources.requests.memory`           | Memory request                                                              | `258Mi`                                    |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `securityContext.allowPrivilegeEscalation` | Allow privilege escalation in the container                             | `false`                                    |
| `storage.useIscsi`                    | Use iSCSI for `/config` volume instead of PVC                               | `false`                                    |
| `persistence.config.enabled`          | Enable persistence for configuration (used if `storage.useIscsi` is false)  | `true`                                     |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `nfs.enabled`                         | Enable NFS volume mount for backups                                         | `false`                                    |
| `nfs.server`                          | NFS server address                                                          | `""`                                       |
| `nfs.path`                            | Path on the NFS server                                                      | `""`                                       |
| `iscsi.enabled`                       | Enable iSCSI volume (used if `storage.useIscsi` is true)                    | `false`                                    |
| `iscsi.targetPortal`                  | iSCSI target portal address                                                 | `""`                                       |
| `iscsi.portals`                       | List of iSCSI target portal addresses                                       | `[]`                                       |
| `iscsi.iqn`                           | iSCSI target IQN                                                            | `""`                                       |
| `iscsi.lun`                           | iSCSI target LUN                                                            | `0`                                        |
| `iscsi.fsType`                        | Filesystem type for the iSCSI volume                                        | `ext4`                                     |
| `iscsi.readOnly`                      | Mount the iSCSI volume as read-only                                         | `false`                                    |
| `hostname`                            | Hostname for the pod                                                        | `overseerr`                                |

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
