# Radarr Helm Chart

This chart deploys [Radarr](https://radarr.video/).

*   **Chart Name:** radarr
*   **Chart Version:** 0.1.4
*   **App Version:** 4.0.0
*   **Description:** A Helm chart to deploy Radarr

## Configuration

The following table lists the configurable parameters of the Radarr chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `default`                                  |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/radarr`               |
| `image.tag`                           | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`                    | Image pull policy                                                           | `IfNotPresent`                             |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `labels`                              | Additional labels to add to resources                                       | `{}`                                       |
| `env.UMASK`                           | Umask setting for the container                                             | `"000"`                                    |
| `livenessProbe.enabled`               | Enable liveness probe                                                       | `true`                                     |
| `livenessProbe.initialDelaySeconds`   | Initial delay for liveness probe                                            | `30`                                       |
| `livenessProbe.periodSeconds`         | Period for liveness probe checks                                            | `60`                                       |
| `livenessProbe.command`               | Command for liveness probe check (reads API key from config.xml)            | (See `values.yaml`)                        |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `7878`                                     |
| `resources.limits.memory`             | Memory limit                                                                | `4Gi`                                      |
| `resources.requests.cpu`              | CPU request                                                                 | `50m`                                      |
| `resources.requests.memory`           | Memory request                                                              | `1Gi`                                      |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `persistence.config.enabled`          | Enable persistence for the `/config` directory                              | `true`                                     |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `nfs.enabled`                         | Enable NFS volume mount for media                                           | `true`                                     |
| `nfs.server`                          | NFS server address                                                          | `"10.3.201.151"`                           |
| `nfs.path`                            | Path on the NFS server                                                      | `"/mnt/zpool/plexmedia"`                   |
| `hostname`                            | Hostname for the pod                                                        | `radarr`                                   |
| `configXml.existingSecret`            | Name of an existing secret containing `config.xml` (skips creation)         | `""`                                       |
| `configXml.bindAddress`               | Bind address for Radarr                                                     | `*`                                        |
| `configXml.port`                      | Port for Radarr HTTP interface                                              | `7878`                                     |
| `configXml.sslPort`                   | Port for Radarr HTTPS interface                                             | `9898`                                     |
| `configXml.enableSsl`                 | Enable SSL/HTTPS                                                            | `"False"`                                  |
| `configXml.launchBrowser`             | Launch browser on startup                                                   | `"True"`                                   |
| `secretConfig.apiKey`                | Radarr API key (required, must be provided here or via secret)             | `""`                                       |
| `configXml.authenticationMethod`      | Authentication method                                                       | `External`                                 |
| `configXml.authenticationRequired`    | Authentication requirement level                                            | `DisabledForLocalAddresses`                |
| `configXml.branch`                    | Radarr update branch                                                        | `main`                                     |
| `configXml.logLevel`                  | Logging level                                                               | `info`                                     |
| `configXml.sslCertPath`               | Path to SSL certificate                                                     | `""`                                       |
| `configXml.sslCertPassword`           | Password for SSL certificate                                                | `""`                                       |
| `configXml.urlBase`                   | URL base for Radarr                                                         | `""`                                       |
| `configXml.instanceName`              | Instance name                                                               | `Radarr`                                   |
| `configXml.updateMechanism`           | Update mechanism                                                            | `Docker`                                   |
| `configXml.postgres.enabled`          | Enable PostgreSQL database backend                                          | `false`                                    |
| `configXml.postgres.user`             | PostgreSQL username                                                         | `""`                                       |
| `configXml.postgres.password`         | PostgreSQL password                                                         | `""`                                       |
| `configXml.postgres.host`             | PostgreSQL host                                                             | `""`                                       |
| `configXml.postgres.port`             | PostgreSQL port                                                             | `""`                                       |
| `configXml.postgres.mainDb`           | PostgreSQL main database name                                               | `""`                                       |
| `configXml.postgres.logDb`            | PostgreSQL log database name                                                | `""`                                       |
| `cloudnativepg.enabled`              | Enable CloudnativePG integration                                            | `false`                                    |
| `cloudnativepg.clusterName`          | CloudnativePG cluster name                                                  | `""`                                       |
| `cloudnativepg.namespace`            | CloudnativePG cluster namespace                                             | `""`                                       |
| `cloudnativepg.secretName`           | Secret name for CloudnativePG credentials (defaults to <clusterName>-app)   | `""`                                       |
| `cloudnativepg.mainDb`               | Main database name                                                          | `radarr-main`                              |
| `cloudnativepg.logDb`                | Log database name                                                           | `radarr-log`                               |
| `cloudnativepg.initContainer.image`  | Image to use for the init container                                         | `t2azcr.azurecr.io/utils/kubectl:v1.333`                   |
| `appConfig.bindAddress`              | Bind address for Radarr                                                     | `*`                                        |
| `appConfig.port`                     | Port for Radarr HTTP interface                                              | `7878`                                     |
| `appConfig.sslPort`                  | Port for Radarr HTTPS interface                                             | `9898`                                     |
| `appConfig.enableSsl`                | Enable SSL/HTTPS                                                            | `"False"`                                  |
| `appConfig.launchBrowser`            | Launch browser on startup                                                   | `"True"`                                   |
| `appConfig.authenticationMethod`     | Authentication method                                                       | `External`                                 |
| `appConfig.authenticationRequired`   | Authentication requirement level                                            | `DisabledForLocalAddresses`                |
| `appConfig.branch`                   | Radarr update branch                                                        | `main`                                     |
| `appConfig.logLevel`                 | Logging level                                                               | `info`                                     |
| `appConfig.sslCertPath`              | Path to SSL certificate                                                     | `""`                                       |
| `appConfig.sslCertPassword`          | Password for SSL certificate                                                | `""`                                       |
| `appConfig.urlBase`                  | URL base for Radarr                                                         | `""`                                       |
| `appConfig.instanceName`             | Instance name                                                               | `Radarr`                                   |
| `appConfig.updateMechanism`          | Update mechanism                                                            | `Docker`                                   |
| `appConfig.postgres.enabled`         | Enable PostgreSQL database backend (legacy)                                 | `false`                                    |
| `appConfig.postgres.user`            | PostgreSQL username                                                         | `""`                                       |
| `appConfig.postgres.host`            | PostgreSQL host                                                             | `""`                                       |
| `appConfig.postgres.port`            | PostgreSQL port                                                             | `5432`                                     |
| `appConfig.postgres.mainDb`          | PostgreSQL main database name                                               | `""`                                       |
| `appConfig.postgres.logDb`           | PostgreSQL log database name                                                | `""`                                       |
| `secretConfig.apiKey`                | Radarr API key (required, must be provided here or via secret)             | `""`                                       |
| `secretConfig.postgresPassword`      | PostgreSQL password (if postgres.enabled is true)                           | `""`                                       |
| `additionalConfig.secretRef.name`    | Secret reference for additional configuration                               | `""`                                       |
| `additionalConfig.secretRef.key`     | Key in the secret for additional configuration                             | `""`                                       |

**Configuration Management (`config.xml`)**

The Radarr `config.xml` file can be managed in several ways:

1. **CloudnativePG Integration (Recommended for PostgreSQL):**
   * When `cloudnativepg.enabled=true`, an init container will fetch database credentials from CloudnativePG secrets.
   * The init container will create or update the `config.xml` file with the PostgreSQL connection details.
   * Existing configuration in `config.xml` will be preserved, with only the necessary fields updated.
   * This method supports dynamic database credentials managed by CloudnativePG.

2. **Static Secret (Legacy):**
   * If `configXmlFromSecret.enabled=true`, the `config.xml` file will be mounted from an existing Secret.
   * Otherwise, if `cloudnativepg.enabled=false`, a new secret named `{{ include "radarr.fullname" . }}-config` will be created using the values from `appConfig` and `secretConfig`.
   * The API key (`secretConfig.apiKey`) must be provided either directly in values or via `secretConfig.apiKeySecretRef`.

3. **Additional Configuration:**
   * You can provide additional configuration via a separate Secret using `additionalConfig.secretRef`.
   * This configuration will be merged with the existing configuration.

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
