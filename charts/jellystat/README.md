# Jellystat Helm Chart

This chart deploys [Jellystat](https://github.com/CyferShepard/Jellystat), a free and open source Statistics App for Jellyfin.

*   **Chart Name:** jellystat
*   **Chart Version:** 1.0.0
*   **App Version:** 1.0.0
*   **Description:** A Helm chart to deploy Jellystat

## Overview

Jellystat is a statistics and monitoring application for Jellyfin that provides:
- Session monitoring and logging
- Statistics for all libraries and users
- Watch history tracking
- User overview and activity
- Backup and restore data functionality
- Auto sync library items
- Jellyfin Statistics Plugin integration

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PostgreSQL database (either standalone or CloudNativePG cluster)

## Configuration

The following table lists the configurable parameters of the Jellystat chart and their default values.

### Basic Configuration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `nameOverride`                        | String to override the chart name                                           | `""`                                       |
| `fullnameOverride`                    | String to override the full release name                                    | `""`                                       |
| `image.repository`                    | Image repository                                                            | `cyfershepard/jellystat`                   |
| `image.tag`                           | Image tag                                                                   | `latest`                                   |
| `image.pullPolicy`                    | Image pull policy                                                           | `IfNotPresent`                             |
| `replicaCount`                        | Number of replicas                                                          | `1`                                        |
| `hostname`                            | Hostname for the pod                                                        | `jellystat`                                |

### Service Configuration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `service.type`                        | Type of Kubernetes service                                                  | `ClusterIP`                                |
| `service.port`                        | Port for the Kubernetes service                                             | `3000`                                     |
| `service.targetPort`                  | Target port for the service                                                 | `3000`                                     |
| `service.annotations`                 | Annotations for the service                                                 | `{}`                                       |
| `service.labels`                      | Labels for the service                                                      | `{}`                                       |

### Ingress Configuration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `ingress.enabled`                     | Enable ingress controller resource                                          | `false`                                    |
| `ingress.className`                   | Ingress class name                                                          | `""`                                       |
| `ingress.annotations`                 | Annotations for the ingress                                                 | `{}`                                       |
| `ingress.hosts`                       | Ingress host configuration                                                  | `[{host: jellystat.local, paths: [{path: /, pathType: ImplementationSpecific}]}]` |
| `ingress.tls`                         | Ingress TLS configuration                                                   | `[]`                                       |

### Resource Configuration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `resources.limits.memory`             | Memory limit                                                                | `2Gi`                                      |
| `resources.requests.cpu`              | CPU request                                                                 | `50m`                                      |
| `resources.requests.memory`           | Memory request                                                              | `512Mi`                                    |

### Persistence Configuration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `persistence.backup.enabled`          | Enable persistence for backup volume                                        | `true`                                     |
| `persistence.backup.type`             | Type of volume (pvc, hostPath, emptyDir, nfs, iscsi)                       | `pvc`                                      |
| `persistence.backup.mountPath`        | Mount path inside the container                                             | `/app/backend/backup-data`                 |
| `persistence.backup.size`             | Size of the PVC                                                             | `1Gi`                                      |
| `persistence.backup.storageClass`     | Storage class for the PVC                                                   | `""`                                       |
| `persistence.backup.existingClaim`    | Name of an existing PVC                                                     | `""`                                       |

### Application Configuration

| Parameter                                      | Description                                                    | Default                |
| ---------------------------------------------- | -------------------------------------------------------------- | ---------------------- |
| `env.TZ`                                       | Timezone                                                       | `Etc/UTC`              |
| `appConfig.baseUrl`                            | Base URL for the application                                   | `/`                    |
| `appConfig.listenIp`                           | Listen IP address (0.0.0.0 for IPv4, :: for IPv6)            | `0.0.0.0`              |
| `appConfig.rejectSelfSignedCertificates`       | Reject self-signed SSL certificates                            | `true`                 |
| `appConfig.minimumSecondsToIncludePlayback`    | Minimum seconds to include playback                            | `1`                    |
| `appConfig.isEmbyApi`                          | Set to true if using Emby instead of Jellyfin                  | `false`                |

### Secret Configuration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `secretConfig.jwtSecret`              | JWT secret for authentication (required)                                    | `""`                                       |
| `secretConfig.jwtSecretRef.name`      | Reference to secret containing JWT secret                                   | `""`                                       |
| `secretConfig.jwtSecretRef.key`       | Key in secret containing JWT secret                                         | `""`                                       |
| `secretConfig.masterUser`             | Master override user (optional)                                             | `""`                                       |
| `secretConfig.masterPassword`         | Master override password (optional)                                         | `""`                                       |
| `secretConfig.geoliteAccountId`       | MaxMind GeoLite account ID for IP geolocation (optional)                   | `""`                                       |
| `secretConfig.geoliteLicenseKey`      | MaxMind GeoLite license key for IP geolocation (optional)                  | `""`                                       |

### PostgreSQL Configuration (Legacy)

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `appConfig.postgres.enabled`          | Enable legacy PostgreSQL support (when cloudnativepg.enabled=false)        | `false`                                    |
| `appConfig.postgres.user`             | PostgreSQL username                                                         | `""`                                       |
| `appConfig.postgres.host`             | PostgreSQL host                                                             | `""`                                       |
| `appConfig.postgres.port`             | PostgreSQL port                                                             | `5432`                                     |
| `appConfig.postgres.database`         | PostgreSQL database name                                                    | `jfstat`                                   |
| `secretConfig.postgresPassword`       | PostgreSQL password                                                         | `""`                                       |

### CloudNativePG Integration

| Parameter                             | Description                                                                 | Default                                    |
| ------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------ |
| `cloudnativepg.enabled`               | Enable CloudnativePG integration                                            | `false`                                    |
| `cloudnativepg.clusterName`           | CloudnativePG cluster name                                                 | `""`                                       |
| `cloudnativepg.namespace`             | CloudnativePG namespace                                                    | `""`                                       |
| `cloudnativepg.secretName`            | CloudnativePG secret name (defaults to <clusterName>-app if not set)       | `""`                                       |
| `cloudnativepg.database`              | Database name                                                              | `jfstat`                                   |
| `cloudnativepg.initContainer.image`   | Init container image                                                       | `t2azcr.azurecr.io/utils/kubectl:v1.33`   |

## Database Configuration

Jellystat requires a PostgreSQL database. There are two ways to configure it:

### Option 1: CloudNativePG Integration (Recommended)

Enable CloudnativePG integration to automatically fetch database credentials from a CloudNativePG cluster:

```yaml
cloudnativepg:
  enabled: true
  clusterName: "my-postgres-cluster"
  namespace: "database"
  database: "jfstat"

secretConfig:
  jwtSecret: "your-jwt-secret-here"
```

The chart will:
1. Create a pre-install/pre-upgrade Job that fetches credentials from the CloudNativePG cluster
2. Store the credentials in a secret
3. Configure the Jellystat deployment to use these credentials

### Option 2: Legacy PostgreSQL Configuration

For standalone PostgreSQL instances:

```yaml
appConfig:
  postgres:
    enabled: true
    user: "jellystat"
    host: "postgres.database.svc.cluster.local"
    port: 5432
    database: "jfstat"

secretConfig:
  postgresPassword: "your-postgres-password"
  jwtSecret: "your-jwt-secret-here"
```

## Required Configuration

The following values **must** be provided:

1. **JWT Secret**: Either `secretConfig.jwtSecret` or `secretConfig.jwtSecretRef` must be set
2. **Database Configuration**: Either enable CloudnativePG integration or configure legacy PostgreSQL settings

## Installation

### Basic Installation with CloudNativePG

```bash
helm install jellystat ./jellystat \
  --set cloudnativepg.enabled=true \
  --set cloudnativepg.clusterName=postgres-cluster \
  --set cloudnativepg.namespace=database \
  --set secretConfig.jwtSecret=your-jwt-secret
```

### Installation with Legacy PostgreSQL

```bash
helm install jellystat ./jellystat \
  --set appConfig.postgres.enabled=true \
  --set appConfig.postgres.host=postgres.database.svc.cluster.local \
  --set appConfig.postgres.user=jellystat \
  --set secretConfig.postgresPassword=your-password \
  --set secretConfig.jwtSecret=your-jwt-secret
```

### Installation with Ingress

```bash
helm install jellystat ./jellystat \
  --set cloudnativepg.enabled=true \
  --set cloudnativepg.clusterName=postgres-cluster \
  --set secretConfig.jwtSecret=your-jwt-secret \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=jellystat.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

## Upgrading

To upgrade the chart:

```bash
helm upgrade jellystat ./jellystat -f values.yaml
```

## Uninstalling

To uninstall/delete the deployment:

```bash
helm delete jellystat
```

## RBAC Permissions

When CloudnativePG integration is enabled, the chart creates the following RBAC resources:

1. **Role in CloudnativePG namespace**: Allows reading the CloudnativePG secret
2. **Role in release namespace**: Allows patching the pgcreds secret
3. **RoleBindings**: Bind the roles to the service account

These permissions are required for the init Job and container to fetch and store database credentials.

## Troubleshooting

### Database Connection Issues

If Jellystat cannot connect to the database:

1. Check the CloudnativePG cluster is running: `kubectl get cluster -n <namespace>`
2. Verify the secret exists: `kubectl get secret <clusterName>-app -n <namespace>`
3. Check the init Job logs: `kubectl logs -n <namespace> job/jellystat-cnpg-init`
4. Verify RBAC permissions are correctly set

### Pod Startup Issues

Check the pod logs:
```bash
kubectl logs -n <namespace> deployment/jellystat
```

### JWT Secret Not Set

If you see errors about missing JWT secret, ensure you've set either:
- `secretConfig.jwtSecret` in values.yaml, or
- `secretConfig.jwtSecretRef` pointing to an existing secret

## Additional Resources

- [Jellystat GitHub Repository](https://github.com/CyferShepard/Jellystat)
- [Jellystat Docker Hub](https://hub.docker.com/r/cyfershepard/jellystat)
- [CloudNativePG Documentation](https://cloudnative-pg.io/)
