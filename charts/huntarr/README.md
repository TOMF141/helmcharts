# Huntarr Helm Chart

This chart deploys [Huntarr (4sonarr)](https://github.com/jshridha/huntarr).

*   **Chart Name:** huntarr
*   **Chart Version:** 0.1.0
*   **App Version:** latest
*   **Description:** A Helm chart for Huntarr (4sonarr)

## Configuration

The following table lists the configurable parameters of the Huntarr chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `image.repository`                    | Image repository                                                            | `huntarr/4sonarr`                          |
| `image.pullPolicy`                    | Image pull policy                                                           | `IfNotPresent`                             |
| `image.tag`                           | Image tag (overrides chart appVersion)                                      | `""` (uses chart `appVersion`)             |
| `imagePullSecrets`                    | Secrets for pulling images from private registries                          | `[]`                                       |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `serviceAccount.create`               | Whether to create a service account                                         | `true`                                     |
| `serviceAccount.annotations`          | Annotations for the service account                                         | `{}`                                       |
| `serviceAccount.name`                 | Name of the service account to use (if not set, generated)                  | `""`                                       |
| `podAnnotations`                      | Annotations to add to the pod                                               | `{}`                                       |
| `podSecurityContext`                  | Pod security context                                                        | `{}`                                       |
| `securityContext`                     | Container security context                                                  | `{}`                                       |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `8988`                                     |
| `resources`                           | Resource requests and limits                                                | `{}`                                       |
| `autoscaling.enabled`                 | Enable Horizontal Pod Autoscaler                                            | `false`                                    |
| `autoscaling.minReplicas`             | Minimum number of replicas for HPA                                          | `1`                                        |
| `autoscaling.maxReplicas`             | Maximum number of replicas for HPA                                          | `100`                                      |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization for HPA                                        | `80`                                       |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `config.apiKey`                       | Sonarr API Key (required if `secretName` and `configSecretName` are empty)  | `"your-api-key"`                           |
| `config.apiUrl`                       | Sonarr API URL (required if `configSecretName` is empty)                    | `"http://your-sonarr-address:8989"`        |
| `config.apiTimeout`                   | API timeout in seconds                                                      | `"60"`                                     |
| `config.monitoredOnly`                | Only hunt for monitored shows                                               | `"true"`                                   |
| `config.huntMissingShows`             | Hunt for missing shows (1=enabled, 0=disabled)                              | `"1"`                                      |
| `config.huntUpgradeEpisodes`          | Hunt for episodes to upgrade quality (1=enabled, 0=disabled)                | `"0"`                                      |
| `config.sleepDuration`                | Sleep duration between hunts in seconds                                     | `"900"`                                    |
| `config.stateResetIntervalHours`      | Interval to reset hunt state in hours                                       | `"168"`                                    |
| `config.debugMode`                    | Enable debug mode                                                           | `"false"`                                  |
| `config.enableWebUi`                  | Enable the web UI                                                           | `"true"`                                   |
| `config.skipFutureEpisodes`           | Skip hunting for future episodes                                            | `"true"`                                   |
| `config.skipSeriesRefresh`            | Skip refreshing series list from Sonarr                                     | `"false"`                                  |
| `config.commandWaitDelay`             | Delay between checking Sonarr command status                                | `"1"`                                      |
| `config.commandWaitAttempts`          | Number of attempts to check Sonarr command status                           | `"600"`                                    |
| `config.minimumDownloadQueueSize`     | Minimum download queue size before hunting                                  | `"-1"`                                     |
| `config.randomMissing`                | Randomize order when hunting missing episodes                               | `"true"`                                   |
| `config.randomUpgrades`               | Randomize order when hunting upgrades                                       | `"true"`                                   |
| `persistence.config.enabled`          | Enable persistence for configuration                                        | `true`                                     |
| `persistence.config.accessMode`       | Access mode for the configuration PVC                                       | `ReadWriteOnce`                            |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `secretName`                          | Name of an existing secret containing *only* the Sonarr API key             | `""`                                       |
| `secretApiKeyName`                    | Key within `secretName` that holds the API key                              | `"api-key"`                                |
| `configSecretName`                    | Name of an existing secret containing *all* configuration key-value pairs   | `""`                                       |

**Configuration Methods:**

You can configure Huntarr in one of three ways (in order of precedence):

1.  **`configSecretName`:** Provide the name of an existing Kubernetes secret containing *all* required configuration variables (e.g., `API_KEY`, `API_URL`). If set, the `config` map and `secretName` are ignored.
2.  **`secretName`:** Provide the name of an existing Kubernetes secret containing *only* the Sonarr API key (using the key specified in `secretApiKeyName`). The rest of the configuration must be provided via the `config` map. If set, `config.apiKey` is ignored.
3.  **`config` map:** Define all configuration values directly within the `values.yaml` file under the `config` key. This is the default method if `configSecretName` and `secretName` are not set.

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
