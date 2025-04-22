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
| `configXml.apiKey`                    | Sonarr API key (auto-generated if empty, **replace default**)               | `"xxxxxxxxxxx"`                            |
| `configXml.authenticationMethod`      | Authentication method                                                       | `External`                                 |
| `configXml.authenticationRequired`    | Authentication requirement level                                            | `DisabledForLocalAddresses`                |
| `configXml.branch`                    | Sonarr update branch                                                        | `main`                                     |
| `configXml.logLevel`                  | Logging level                                                               | `info`                                     |
| `configXml.sslCertPath`               | Path to SSL certificate                                                     | `""`                                       |
| `configXml.sslCertPassword`           | Password for SSL certificate                                                | `""`                                       |
| `configXml.urlBase`                   | URL base for Sonarr                                                         | `""`                                       |
| `configXml.instanceName`              | Instance name                                                               | `Sonarr`                                   |
| `configXml.updateMechanism`           | Update mechanism                                                            | `Docker`                                   |
| `configXml.postgres.enabled`          | Enable PostgreSQL database backend                                          | `false`                                    |
| `configXml.postgres.user`             | PostgreSQL username                                                         | `""`                                       |
| `configXml.postgres.password`         | PostgreSQL password                                                         | `""`                                       |
| `configXml.postgres.host`             | PostgreSQL host                                                             | `""`                                       |
| `configXml.postgres.port`             | PostgreSQL port                                                             | `5432`                                     |
| `configXml.postgres.mainDb`           | PostgreSQL main database name                                               | `""`                                       |
| `configXml.postgres.logDb`            | PostgreSQL log database name                                                | `""`                                       |

**Configuration Management (`config.xml`)**

The Sonarr `config.xml` file is managed via a Kubernetes Secret.

*   If `configXml.existingSecret` is set to the name of a pre-existing secret containing a `config.xml` key, that secret will be used.
*   Otherwise, a new secret named `{{ include "sonarr.fullname" . }}-config` will be created, templated using the values under the `configXml` section.
*   **Important:** The default `configXml.apiKey` is a placeholder (`xxxxxxxxxxx`). You should either provide a pre-existing secret via `configXml.existingSecret` or set a secure `configXml.apiKey` value when installing the chart if you are not using an existing secret. If left empty when creating a new secret, Sonarr will generate one on first run, but accessing it might require exec-ing into the pod.

Specify parameters using `--set key=value[,key=value]` on the `helm install` or `helm upgrade` command line. Alternatively, a YAML file that specifies the values for the parameters can be provided using the `-f` flag.
