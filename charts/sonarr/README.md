# Sonarr Helm Chart

This chart deploys [Sonarr](https://sonarr.tv/).

*   **Chart Name:** sonarr
*   **Chart Version:** 0.1.6
*   **App Version:** 4.0.0
*   **Description:** A Helm chart to deploy Sonarr

## Configuration

The following table lists the configurable parameters of the Sonarr chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `default`                                  |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/sonarr`               |
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
| `service.port`                        | Port for the Kubernetes service                                             | `8989`                                     |
| `resources.limits.memory`             | Memory limit                                                                | `4Gi`                                      |
| `resources.requests.cpu`              | CPU request                                                                 | `50m`                                      |
| `resources.requests.memory`           | Memory request                                                              | `256Mi`                                    |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `persistence.config.enabled`          | Enable persistence for the `/config` directory                              | `true`                                     |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `nfs.enabled`                         | Enable NFS volume mount for media                                           | `true`                                     |
| `nfs.server`                          | NFS server address                                                          | `"10.3.200.151"`                           |
| `nfs.path`                            | Path on the NFS server                                                      | `"/mnt/zpool/plexmedia"`                   |
| `hostname`                            | Hostname for the pod                                                        | `sonarr`                                   |
| `configXml.existingSecret`            | Name of an existing secret containing `config.xml` (skips creation)         | `""`                                       |
| `configXml.bindAddress`               | Bind address for Sonarr                                                     | `*`                                        |
| `configXml.port`                      | Port for Sonarr HTTP interface                                              | `8989`                                     |
| `configXml.sslPort`                   | Port for Sonarr HTTPS interface                                             | `9898`                                     |
| `configXml.enableSsl`                 | Enable SSL/HTTPS                                                            | `"False"`                                  |
| `configXml.launchBrowser`             | Launch browser on startup                                                   | `"True"`                                   |
| `secretConfig.apiKey`                | Sonarr API key (required, must be provided here or via secret)             | `""`                                       |
| `configXml.authenticationMethod`      | Authentication method                                                       | `External`                                 |
| `configXml.authenticationRequired`    | Authentication requirement level                                            | `DisabledForLocalAddresses`                |
| `configXml.branch`                    | Sonarr update branch                                                        | `main`                                     |
| `configXml.logLevel`                  | Logging level                                                               | `info`                                     |
| `configXml.sslCertPath`               | Path to SSL certificate                                                     | `""`                                       |
| `configXml.sslCertPassword`           | Password for SSL certificate                                                | `""`                                       |
| `configXml.urlBase`                   | URL base for Sonarr                                                         | `""`                                       |
| `configXml.instanceName`              | Instance name                                                               | `Sonarr`                                   |
| `configXml.updateMechanism`           | Update mechanism                                                            | `Docker`                                   |
| `appConfig.bindAddress`              | Bind address for the web interface                                         | `"*"`                                     |
| `appConfig.port`                      | Port for the web interface                                                 | `8989`                                     |
| `appConfig.sslPort`                   | SSL port for the web interface                                             | `9898`                                     |
| `appConfig.enableSsl`                 | Enable SSL for the web interface                                           | `"False"`                                 |
| `appConfig.launchBrowser`             | Launch browser on startup                                                  | `"True"`                                  |
| `appConfig.authenticationMethod`      | Authentication method                                                      | `"External"`                              |
| `appConfig.authenticationRequired`    | Authentication requirement level                                           | `"DisabledForLocalAddresses"`             |
| `appConfig.branch`                    | Branch to use for updates                                                  | `"main"`                                  |
| `appConfig.logLevel`                  | Log level                                                                  | `"info"`                                  |
| `appConfig.sslCertPath`               | SSL certificate path                                                        | `""`                                       |
| `appConfig.urlBase`                   | URL base                                                                   | `""`                                       |
| `appConfig.instanceName`              | Instance name                                                              | `"Sonarr"`                                |
| `appConfig.updateMechanism`           | Update mechanism                                                           | `"Docker"`                                |
| `appConfig.postgres.enabled`          | Enable legacy PostgreSQL support (when cloudnativepg.enabled=false)        | `false`                                    |
| `appConfig.postgres.user`             | PostgreSQL username                                                         | `""`                                       |
| `appConfig.postgres.host`             | PostgreSQL host                                                             | `""`                                       |
| `appConfig.postgres.port`             | PostgreSQL port                                                             | `5432`                                     |
| `appConfig.postgres.mainDb`           | PostgreSQL main database name                                               | `""`                                       |
| `appConfig.postgres.logDb`            | PostgreSQL log database name                                                | `""`                                       |
| `secretConfig.apiKey`                 | API key for Sonarr                                                         | `""`                                       |
| `secretConfig.sslCertPassword`        | SSL certificate password                                                    | `""`                                       |
| `secretConfig.postgresPassword`       | PostgreSQL password (used with appConfig.postgres)                          | `""`                                       |
| `secretConfig.existingSecretName`     | Use an existing secret for configuration                                   | `""`                                       |
| `cloudnativepg.enabled`               | Enable CloudnativePG integration                                            | `false`                                    |
| `cloudnativepg.clusterName`           | CloudnativePG cluster name                                                 | `""`                                       |
| `cloudnativepg.namespace`             | CloudnativePG namespace                                                    | `""`                                       |
| `cloudnativepg.secretName`            | CloudnativePG secret name (defaults to <clusterName>-app if not set)       | `""`                                       |
| `cloudnativepg.mainDbName`            | Main database name                                                         | `"sonarr-main"`                           |
| `cloudnativepg.logDbName`             | Log database name                                                          | `"sonarr-log"`                            |
| `cloudnativepg.initContainerImage`    | Init container image                                                       | `"harbor.tf141.me/utils/kubectl:v1.33"`                |
| `additionalConfig.enabled`            | Enable additional configuration                                            | `false`                                    |
| `additionalConfig.secretName`         | Secret name containing additional configuration                            | `""`                                       |
| `additionalConfig.secretKey`          | Secret key containing additional configuration                             | `""`                                       |

**Configuration Management (`config.xml`)**

There are three ways to manage Sonarr's `config.xml` file:

1. **CloudnativePG Integration (Recommended)**
   * Enable with `cloudnativepg.enabled=true`
   * Specify the CloudnativePG cluster details (`clusterName`, `namespace`, etc.)
   * An init container will fetch database credentials from the CloudnativePG secret and dynamically generate or update the `config.xml` file
   * If an existing `config.xml` is found, only the necessary PostgreSQL settings will be updated, preserving other user customizations

2. **Static Secret (Legacy)**
   * Used when `cloudnativepg.enabled=false`
   * If `secretConfig.existingSecretName` is set, that secret will be used
   * Otherwise, a new secret named `<release-name>-sonarr-config` will be created using values from `appConfig` and `secretConfig`
   * **Important:** The `secretConfig.apiKey` is required and must be provided either directly in values or via `secretConfig.apiKeySecretRef`. The chart will fail to deploy if no API key is provided

3. **Additional Configuration**
   * Enable with `additionalConfig.enabled=true`
   * Specify a secret containing additional configuration to merge with the base configuration
   * This can be used to add custom settings not covered by the standard options

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
