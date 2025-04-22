# Prowlarr Helm Chart

This chart deploys [Prowlarr](https://prowlarr.com/).

*   **Chart Name:** prowlarr
*   **Chart Version:** 0.1.2
*   **App Version:** 1.0.0
*   **Description:** A Helm chart to deploy Prowlarr

## Configuration

The following table lists the configurable parameters of the Prowlarr chart and their default values.

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `namespace`                           | Namespace to deploy the chart into                                          | `default`                                  |
| `image.repository`                    | Image repository                                                            | `lscr.io/linuxserver/prowlarr`             |
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
| `service.port`                        | Port for the Kubernetes service                                             | `9696`                                     |
| `resources.limits.memory`             | Memory limit                                                                | `512Mi`                                    |
| `resources.requests.cpu`              | CPU request                                                                 | `50m`                                      |
| `resources.requests.memory`           | Memory request                                                              | `128Mi`                                    |
| `nodeSelector`                        | Node labels for pod assignment                                              | `{}`                                       |
| `tolerations`                         | Tolerations for node taints                                                 | `[]`                                       |
| `affinity`                            | Affinity rules for pod assignment                                           | `{}`                                       |
| `persistence.config.enabled`          | Enable persistence for the `/config` directory                              | `true`                                     |
| `persistence.config.size`             | Size of the configuration persistent volume                                 | `1Gi`                                      |
| `persistence.config.existingClaim`    | Name of an existing PVC for configuration                                   | `""`                                       |
| `persistence.config.storageClass`     | Storage class for the configuration PVC                                     | `""`                                       |
| `hostname`                            | Hostname for the pod                                                        | `prowlarr`                                 |
| `configXml.existingSecret`            | Name of an existing secret containing `config.xml` (skips creation)         | `""`                                       |
| `configXml.bindAddress`               | Bind address for Prowlarr                                                   | `*`                                        |
| `configXml.port`                      | Port for Prowlarr HTTP interface                                            | `9696`                                     |
| `configXml.sslPort`                   | Port for Prowlarr HTTPS interface                                           | `9697`                                     |
| `configXml.enableSsl`                 | Enable SSL/HTTPS                                                            | `"False"`                                  |
| `configXml.launchBrowser`             | Launch browser on startup                                                   | `"True"`                                   |
| `configXml.apiKey`                    | Prowlarr API key (auto-generated if empty)                                  | `""`                                       |
| `configXml.authenticationMethod`      | Authentication method                                                       | `External`                                 |
| `configXml.authenticationRequired`    | Authentication requirement level                                            | `DisabledForLocalAddresses`                |
| `configXml.branch`                    | Prowlarr update branch                                                      | `main`                                     |
| `configXml.logLevel`                  | Logging level                                                               | `info`                                     |
| `configXml.sslCertPath`               | Path to SSL certificate                                                     | `""`                                       |
| `configXml.sslCertPassword`           | Password for SSL certificate                                                | `""`                                       |
| `configXml.urlBase`                   | URL base for Prowlarr                                                       | `""`                                       |
| `configXml.instanceName`              | Instance name                                                               | `Prowlarr`                                 |
| `configXml.updateMechanism`           | Update mechanism                                                            | `Docker`                                   |
| `configXml.postgres.enabled`          | Enable PostgreSQL database backend                                          | `false`                                    |
| `configXml.postgres.user`             | PostgreSQL username                                                         | `""`                                       |
| `configXml.postgres.password`         | PostgreSQL password                                                         | `""`                                       |
| `configXml.postgres.host`             | PostgreSQL host                                                             | `""`                                       |
| `configXml.postgres.port`             | PostgreSQL port                                                             | `""`                                       |
| `configXml.postgres.mainDb`           | PostgreSQL main database name                                               | `""`                                       |
| `configXml.postgres.logDb`            | PostgreSQL log database name                                                | `""`                                       |

**Configuration Management (`config.xml`)**

The Prowlarr `config.xml` file is managed via a Kubernetes Secret.

*   If `configXml.existingSecret` is set to the name of a pre-existing secret containing a `config.xml` key, that secret will be used.
*   Otherwise, a new secret named `{{ include "prowlarr.fullname" . }}-config` will be created, templated using the values under the `configXml` section.
*   The API key (`configXml.apiKey`) will be automatically generated if left empty.

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
