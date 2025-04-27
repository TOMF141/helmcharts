# Autoscan Helm Chart

This chart deploys [autoscan](https://github.com/Cloudbox/autoscan).

*   **Chart Name:** autoscan
*   **Chart Version:** 0.1.8 (Needs update after standardization)
*   **App Version:** 1.0.0 (Needs update to actual app version)

## Prerequisites

*   Kubernetes 1.19+
*   Helm 3.2.0+
*   PV provisioner support in the underlying infrastructure (if using `persistence.type: pvc`)

## Installing the Chart

To install the chart with the release name `my-autoscan`:

```bash
helm repo add my-repo https://charts.example.com/ # Add your repo URL here
helm install my-autoscan my-repo/autoscan
```

## Uninstalling the Chart

To uninstall/delete the `my-autoscan` deployment:

```bash
helm uninstall my-autoscan
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Autoscan chart and their default values.

| Parameter                             | Description                                                                                                | Default                                    |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name.                                                                         | `""`                                       |
| `fullnameOverride`                    | String to override the full release name.                                                                  | `""`                                       |
| `replicaCount`                        | Number of replicas for the deployment.                                                                     | `1`                                        |
| `image.repository`                    | Container image repository.                                                                                | `cloudb0x/autoscan`                        |
| `image.pullPolicy`                    | Container image pull policy.                                                                               | `IfNotPresent`                             |
| `image.tag`                           | Container image tag. Defaults to `.Chart.AppVersion`.                                                      | `""`                                       |
| `imagePullSecrets`                    | Optional list of image pull secrets.                                                                       | `[]`                                       |
| `extraLabels`                         | Optional extra labels to add to all resources.                                                             | `{}`                                       |
| `strategy.type`                       | Deployment strategy type.                                                                                  | `RollingUpdate`                            |
| `strategy.rollingUpdate.maxSurge`     | Maximum number of pods that can be created over the desired number of pods during an update.               | `"25%"`                                    |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be unavailable during the update process.                                  | `"25%"`                                    |
| `serviceAccount.create`               | Specifies whether a service account should be created.                                                     | `true`                                     |
| `serviceAccount.name`                 | The name of the service account to use. If not set and create is true, a name is generated.                | `""`                                       |
| `serviceAccount.annotations`          | Annotations to add to the service account.                                                                 | `{}`                                       |
| `podAnnotations`                      | Annotations to add to the pod.                                                                             | `{}`                                       |
| `podLabels`                           | Labels to add to the pod.                                                                                  | `{}`                                       |
| `deploymentAnnotations`               | Annotations to add to the deployment.                                                                      | `{}`                                       |
| `podSecurityContext`                  | Security context for the pod (e.g., `fsGroup`, `runAsUser`).                                               | `{}`                                       |
| `containerSecurityContext`            | Security context for the container (e.g., `allowPrivilegeEscalation`, `readOnlyRootFilesystem`).           | `{}`                                       |
| `service.type`                        | Kubernetes service type.                                                                                   | `ClusterIP`                                |
| `service.port`                        | Service port.                                                                                              | `3030`                                     |
| `service.targetPort`                  | Service target port. Defaults to `service.port`.                                                           | `3030`                                     |
| `service.nodePort`                    | Node port (only used if type is NodePort).                                                                 | `null`                                     |
| `service.annotations`                 | Annotations for the service.                                                                               | `{}`                                       |
| `service.labels`                      | Labels for the service.                                                                                    | `{}`                                       |
| `ingress.enabled`                     | Enable ingress controller resource.                                                                        | `false`                                    |
| `ingress.className`                   | Ingress class name.                                                                                        | `""`                                       |
| `ingress.annotations`                 | Annotations for the ingress.                                                                               | `{}`                                       |
| `ingress.hosts[0].host`               | Ingress host name.                                                                                         | `autoscan.local`                           |
| `ingress.hosts[0].paths[0].path`      | Ingress path.                                                                                              | `/`                                        |
| `ingress.hosts[0].paths[0].pathType`  | Ingress path type (e.g., `ImplementationSpecific`, `Prefix`, `Exact`).                                     | `ImplementationSpecific`                   |
| `ingress.tls`                         | Ingress TLS configuration.                                                                                 | `[]`                                       |
| `resources.limits.cpu`                | CPU limit for the container.                                                                               | `50m`                                      |
| `resources.limits.memory`             | Memory limit for the container.                                                                            | `128Mi`                                    |
| `resources.requests.cpu`              | CPU request for the container.                                                                             | `10m`                                      |
| `resources.requests.memory`           | Memory request for the container.                                                                          | `64Mi`                                     |
| `livenessProbe.enabled`               | Enable liveness probe.                                                                                     | `true`                                     |
| `livenessProbe.type`                  | Type of probe (`httpGet`, `tcpSocket`, `exec`).                                                            | `httpGet`                                  |
| `livenessProbe.path`                  | Path for httpGet probe.                                                                                    | `/`                                        |
| `livenessProbe.port`                  | Port for httpGet/tcpSocket probe (references service port).                                                | `http` (`3030`)                            |
| `livenessProbe.initialDelaySeconds`   | Initial delay for the probe.                                                                               | `30`                                       |
| `livenessProbe.periodSeconds`         | How often to perform the probe.                                                                            | `30`                                       |
| `livenessProbe.timeoutSeconds`        | When the probe times out.                                                                                  | `5`                                        |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed.                                        | `3`                                        |
| `readinessProbe.enabled`              | Enable readiness probe.                                                                                    | `true`                                     |
| `readinessProbe.type`                 | Type of probe (`httpGet`, `tcpSocket`, `exec`).                                                            | `httpGet`                                  |
| `readinessProbe.path`                 | Path for httpGet probe.                                                                                    | `/`                                        |
| `readinessProbe.port`                 | Port for httpGet/tcpSocket probe (references service port).                                                | `http` (`3030`)                            |
| `readinessProbe.initialDelaySeconds`  | Initial delay for the probe.                                                                               | `15`                                       |
| `readinessProbe.periodSeconds`        | How often to perform the probe.                                                                            | `15`                                       |
| `readinessProbe.timeoutSeconds`       | When the probe times out.                                                                                  | `5`                                        |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed.                                        | `3`                                        |
| `persistence.config.enabled`          | Enable persistence for config volume.                                                                      | `true`                                     |
| `persistence.config.type`             | Type of volume (`pvc`, `hostPath`, `emptyDir`, `nfs`, `iscsi`).                                            | `pvc`                                      |
| `persistence.config.mountPath`        | Mount path inside the container for config.                                                                | `/config`                                  |
| `persistence.config.accessModes`      | PVC access modes.                                                                                          | `[ReadWriteOnce]`                          |
| `persistence.config.size`             | PVC size.                                                                                                  | `500Mi`                                    |
| `persistence.config.storageClass`     | PVC storage class. If `""`, uses default.                                                                  | `""`                                       |
| `persistence.config.existingClaim`    | Use an existing PVC instead of creating one.                                                               | `""`                                       |
| `persistence.database.enabled`        | Enable persistence for database volume.                                                                    | `true`                                     |
| `persistence.database.type`           | Type of volume (`pvc`, `hostPath`, `emptyDir`, `nfs`, `iscsi`).                                            | `pvc`                                      |
| `persistence.database.mountPath`      | Mount path inside the container for database.                                                              | `/database`                                |
| `persistence.database.accessModes`    | PVC access modes.                                                                                          | `[ReadWriteOnce]`                          |
| `persistence.database.size`           | PVC size.                                                                                                  | `500Mi`                                    |
| `persistence.database.storageClass`   | PVC storage class. If `""`, uses default.                                                                  | `""`                                       |
| `persistence.database.existingClaim`  | Use an existing PVC instead of creating one.                                                               | `""`                                       |
| `nodeSelector`                        | Node selector configuration.                                                                               | `{}`                                       |
| `tolerations`                         | Tolerations configuration.                                                                                 | `[]`                                       |
| `affinity`                            | Affinity configuration.                                                                                    | `{}`                                       |
| `env`                                 | Environment variables passed directly to the container (e.g., `TZ`, `PUID`, `PGID`).                       | `{}`                                       |
| `envFrom`                             | Environment variables sourced from ConfigMaps or Secrets.                                                  | `[]`                                       |
| `appConfig.minimumAge`                | Corresponds to `minimum_age` in `config.yml`.                                                              | `"5m"`                                     |
| `appConfig.scanDelay`                 | Corresponds to `scan_delay` in `config.yml`.                                                               | `"30s"`                                    |
| `appConfig.triggers.lidarr.enabled`   | Enable Lidarr trigger in `config.yml`.                                                                     | `true`                                     |
| `appConfig.triggers.lidarr.priority`  | Priority for Lidarr trigger in `config.yml`.                                                               | `1`                                        |
| `appConfig.triggers.radarr.enabled`   | Enable Radarr trigger in `config.yml`.                                                                     | `true`                                     |
| `appConfig.triggers.radarr.priority`  | Priority for Radarr trigger in `config.yml`.                                                               | `2`                                        |
| `appConfig.triggers.sonarr.enabled`   | Enable Sonarr trigger in `config.yml`.                                                                     | `true`                                     |
| `appConfig.triggers.sonarr.priority`  | Priority for Sonarr trigger in `config.yml`.                                                               | `2`                                        |
| `appConfig.targets.plex.url`          | URL for the Plex target in `config.yml`.                                                                   | `""`                                       |
| `secretConfig.existingSecretName`     | Name of an existing secret containing `config.yml`. If set, the chart will not render its own config secret. | `""`                                       |
| `secretConfig.existingSecretKey`      | Key within the existing secret that holds the `config.yml` content.                                        | `"config.yml"`                             |
| `secretConfig.targets.plex.token`     | Plex token (sensitive). Stored in the chart-managed secret if `existingSecretName` is empty.               | `""`                                       |
| `secretConfig.targets.plex.tokenSecretRef.name` | Reference an existing secret containing only the Plex token. Overrides `secretConfig.targets.plex.token`. | `""`                                       |
| `secretConfig.targets.plex.tokenSecretRef.key` | Key within the referenced secret containing the Plex token.                                        | `""`                                       |

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
