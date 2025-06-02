# Lidarr Helm Chart

This chart deploys [Lidarr](https://lidarr.audio/).

*   **Chart Name:** lidarr
*   **Chart Version:** 1.0.0
*   **App Version:** 2.0.0
*   **Description:** A Helm chart to deploy Lidarr

## Configuration

The following table lists the configurable parameters of the Lidarr chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `default`                                  |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/lidarr`               |
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
| `service.port`                        | Port for the Kubernetes service                                             | `8686`                                     |
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
| `hostname`                            | Hostname for the pod                                                        | `lidarr`                                   |
| `configXml.existingSecret`            | Name of an existing secret containing `config.xml` (skips creation)         | `""`                                       |
| `configXml.bindAddress`               | Bind address for Lidarr                                                     | `*`                                        |
| `configXml.port`                      | Port for Lidarr HTTP interface                                              | `8686`                                     |
| `configXml.sslPort`                   | Port for Lidarr HTTPS interface                                             | `9898`                                     |
| `configXml.enableSsl`                 | Enable SSL/HTTPS                                                            | `"False"`                                  |
| `configXml.launchBrowser`             | Launch browser on startup                                                   | `"True"`                                   |
| `configXml.apiKey`                    | Lidarr API key (auto-generated if empty, **replace default**)               | `"xxxxxxxxxxx"`                            |
| `configXml.authenticationMethod`      | Authentication method                                                       | `External`                                 |
| `configXml.authenticationRequired`    | Authentication requirement level                                            | `DisabledForLocalAddresses`                |
| `configXml.branch`                    | Lidarr update branch                                                        | `main`                                     |
| `configXml.logLevel`                  | Logging level                                                               | `info`                                     |
| `configXml.sslCertPath`               | Path to SSL certificate                                                     | `""`                                       |
| `configXml.sslCertPassword`           | Password for SSL certificate                                                | `""`                                       |
| `configXml.urlBase`                   | URL base for Lidarr                                                         | `""`                                       |
| `configXml.instanceName`              | Instance name                                                               | `Lidarr`                                   |
| `configXml.updateMechanism`           | Update mechanism                                                            | `Docker`                                   |
| `configXml.postgres.enabled`          | Enable PostgreSQL database backend                                          | `false`                                    |
| `configXml.postgres.user`             | PostgreSQL username                                                         | `""`                                       |
| `configXml.postgres.password`         | PostgreSQL password                                                         | `""`                                       |
| `configXml.postgres.host`             | PostgreSQL host                                                             | `""`                                       |
| `configXml.postgres.port`             | PostgreSQL port                                                             | `5432`                                     |
| `configXml.postgres.mainDb`           | PostgreSQL main database name                                               | `""`                                       |
| `configXml.postgres.logDb`            | PostgreSQL log database name                                                | `""` |

## CloudnativePG Integration

This chart supports integration with [CloudnativePG](https://cloudnative-pg.io/) for PostgreSQL database connectivity. When enabled, an init container will dynamically fetch database credentials from CloudnativePG secrets and update the Lidarr configuration.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `cloudnativepg.enabled`               | Enable CloudnativePG integration                                            | `false`                                    |
| `cloudnativepg.clusterName`           | CloudnativePG cluster name                                                  | `""`                                       |
| `cloudnativepg.namespace`             | CloudnativePG cluster namespace                                             | `""`                                       |
| `cloudnativepg.secretName`            | Secret name for CloudnativePG credentials (defaults to <clusterName>-app)   | `""`                                       |
| `cloudnativepg.mainDb`                | Main database name                                                          | `"lidarr-main"`                            |
| `cloudnativepg.logDb`                 | Log database name                                                           | `"lidarr-log"`                             |
| `cloudnativepg.initContainer.image`   | Image to use for the init container                                         | `"bitnami/kubectl:latest"`                 |
| `cloudnativepg.initContainer.resources` | Resource limits for the init container                                      | See `values.yaml`                           |
| `additionalConfig.secretRef.name`     | Secret reference for additional configuration                               | `""`                                       |
| `additionalConfig.secretRef.key`      | Key in the secret for additional configuration                              | `""`                                       |

**Note:** When `cloudnativepg.enabled` is set to `true`, the legacy PostgreSQL configuration in `appConfig.postgres` is ignored, and the static `config.xml` secret is not created. Instead, the init container will fetch database credentials from the CloudnativePG secret and dynamically update or create the `config.xml` file.                                      |

**Configuration Management (`config.xml`)**

The Lidarr `config.xml` file is managed via a Kubernetes Secret.

*   If `configXml.existingSecret` is set to the name of a pre-existing secret containing a `config.xml` key, that secret will be used.
*   Otherwise, a new secret named `{{ include "lidarr.fullname" . }}-config` will be created, templated using the values under the `configXml` section.
*   **Important:** The default `configXml.apiKey` is a placeholder (`xxxxxxxxxxx`). You should either provide a pre-existing secret via `configXml.existingSecret` or set a secure `configXml.apiKey` value when installing the chart if you are not using an existing secret. If left empty when creating a new secret, Lidarr will generate one on first run, but accessing it might require exec-ing into the pod.

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
