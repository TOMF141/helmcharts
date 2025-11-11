# Sabnzbd Helm Chart

This chart deploys [Sabnzbd](https://sabnzbd.org/).

*   **Chart Name:** sabnzbd
*   **Chart Version:** 0.1.1
*   **App Version:** latest
*   **Description:** A Helm chart for Sabnzbd Usenet downloader

## Configuration

The following table lists the configurable parameters of the Sabnzbd chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `download`                                 |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/sabnzbd`              |
| `image.tag`                           | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`                    | Image pull policy                                                           | `Always`                                   |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `labels`                              | Additional labels to add to resources                                       | (See `values.yaml`)                        |
| `env.UMASK`                           | Umask setting for the container                                             | `"000"`                                    |
| `env.DOCKER_MODS`                     | Docker Mods for theme installation (e.g., Theme Park)                       | `ghcr.io/gilbn/theme.park:sabnzbd`         |
| `env.TP_THEME`                        | Theme Park theme name                                                       | `space-gray`                               |
| `livenessProbe.enabled`               | Enable liveness probe                                                       | `true`                                     |
| `livenessProbe.initialDelaySeconds`   | Initial delay for liveness probe                                            | `30`                                       |
| `livenessProbe.periodSeconds`         | Period for liveness probe checks                                            | `60`                                       |
| `livenessProbe.timeoutSeconds`        | Timeout for liveness probe check                                            | `1`                                        |
| `livenessProbe.failureThreshold`      | Failure threshold for liveness probe                                        | `3`                                        |
| `livenessProbe.successThreshold`      | Success threshold for liveness probe                                        | `1`                                        |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `8080`                                     |
| `resources.limits.cpu`                | CPU limit                                                                   | `"2"`                                      |
| `resources.limits.memory`             | Memory limit                                                                | `5Gi`                                      |
| `resources.requests.cpu`              | CPU request                                                                 | `"1"`                                      |
| `resources.requests.memory`           | Memory request                                                              | `2Gi`                                      |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `persistence.config.enabled`          | Enable persistence for the `/config` directory                              | `true`                                     |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `sabnzbd-config`                           |
| `persistence.config.mountPath`        | Mount path for configuration volume                                         | `/config`                                  |
| `nfs.download.enabled`                | Enable NFS mount for temporary downloads                                    | `true`                                     |
| `nfs.download.server`                 | NFS server address for downloads                                            | `"10.3.200.252"`                           |
| `nfs.download.path`                   | Path on the NFS server for downloads                                        | `"/mnt/download/sabnzbd"`                  |
| `nfs.download.mountPath`              | Mount path inside container for downloads                                   | `/download-temp`                           |
| `nfs.plexmedia.enabled`               | Enable NFS mount for final media location                                   | `true`                                     |
| `nfs.plexmedia.server`                | NFS server address for media                                                | `"10.3.201.151"`                           |
| `nfs.plexmedia.path`                  | Path on the NFS server for media                                            | `"/mnt/zpool/plexmedia"`                   |
| `nfs.plexmedia.mountPath`             | Mount path inside container for media                                       | `/zpool/plexmedia`                         |
| `hostname`                            | Hostname for the pod                                                        | `sabnzbd`                                  |
| `podAnnotations`                      | Annotations to add to the Pod                                               | (See `values.yaml`)                        |
| `deploymentAnnotations`               | Annotations to add to the Deployment                                        | `{}`                                       |

**Notes:**

*   The `livenessProbe.command` is commented out in the default `values.yaml`. You may need to uncomment and configure it if the default HTTP check on port 8080 is insufficient.
*   For `persistence.config`, if `existingClaim` is not provided, you can configure `size` and `storageClass` to create a new PVC.

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
