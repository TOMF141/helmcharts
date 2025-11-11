# Tautulli Helm Chart

This chart deploys [Tautulli](https://tautulli.com/).

*   **Chart Name:** tautulli
*   **Chart Version:** 0.1.6
*   **App Version:** latest
*   **Description:** A Helm chart to deploy Tautulli - a monitoring and tracking tool for Plex Media Server

## Configuration

The following table lists the configurable parameters of the Tautulli chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `default`                                  |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/tautulli`             |
| `image.tag`                           | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`                    | Image pull policy                                                           | `IfNotPresent`                             |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `labels`                              | Additional labels to add to resources                                       | `{}`                                       |
| `env.DOCKER_MODS`                     | Docker Mods for theme installation (e.g., Theme Park)                       | `ghcr.io/gilbn/theme.park:tautulli`        |
| `env.TP_THEME`                        | Theme Park theme name                                                       | `space-gray`                               |
| `livenessProbe.enabled`               | Enable liveness probe                                                       | `true`                                     |
| `livenessProbe.initialDelaySeconds`   | Initial delay for liveness probe                                            | `30`                                       |
| `livenessProbe.periodSeconds`         | Period for liveness probe checks                                            | `60`                                       |
| `livenessProbe.command`               | Command for liveness probe check                                            | `curl --fail localhost:8181/status`        |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `8181`                                     |
| `resources.limits.memory`             | Memory limit                                                                | `2Gi`                                      |
| `resources.requests.cpu`              | CPU request                                                                 | `50m`                                      |
| `resources.requests.memory`           | Memory request                                                              | `1Gi`                                      |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `securityContext.allowPrivilegeEscalation` | Allow privilege escalation in the container                             | `false`                                    |
| `storage.useIscsi`                    | Use iSCSI for `/config` volume instead of PVC                               | `false`                                    |
| `persistence.config.enabled`          | Enable persistence for configuration (used if `storage.useIscsi` is false)  | `true`                                     |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `nfs.enabled`                         | Enable NFS volume mount for backups                                         | `true`                                     |
| `nfs.server`                          | NFS server address for backups                                              | `"10.3.201.151"`                           |
| `nfs.path`                            | Path on the NFS server for backups                                          | `"/mnt/kubebackup/kube-prod/tautulli"`     |
| `iscsi.enabled`                       | Enable iSCSI volume (used if `storage.useIscsi` is true)                    | `false`                                    |
| `iscsi.targetPortal`                  | iSCSI target portal address                                                 | `"10.0.2.15:3260"`                         |
| `iscsi.portals`                       | List of iSCSI target portal addresses                                       | `[]`                                       |
| `iscsi.iqn`                           | iSCSI target IQN                                                            | `"iqn.2001-04.com.example:storage.kube.sys1.xyz"` |
| `iscsi.lun`                           | iSCSI target LUN                                                            | `0`                                        |
| `iscsi.fsType`                        | Filesystem type for the iSCSI volume                                        | `ext4`                                     |
| `iscsi.readOnly`                      | Mount the iSCSI volume as read-only                                         | `false`                                    |
| `hostname`                            | Hostname for the pod                                                        | `tautulli`                                 |

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
