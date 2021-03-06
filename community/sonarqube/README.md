# SonarQube

[SonarQube](https://www.sonarqube.org/) is an open sourced code quality scanning tool.

## Introduction

This chart bootstraps a SonarQube instance with a PostgreSQL database.

## Prerequisites

- Kubernetes 1.6+

## Installing the chart

To install the chart :

```bash
$ helm install community/sonarqube
```

The above command deploys Sonarqube on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

The default login is admin/admin.

### Secrets

The secure and recommended approach to provide sensitive data like passwords is to generate a secret containing the sensitive data and providing the pre-created secret name during chart deployment.

If you are using an external database, you should provide an existing secret containing the external database password. The existing secret can be provided as a value to `postgresql.postgresPasswordSecret` or `mysql.mysqlPasswordSecret`.

If creating a secret, it is recommended to name the secret as release-name-secret-name. For example: MyRelease-MySecret

This allows the secrets to be affiliated with the release, but not directly included with the release.

### Image Security Policies

If the cluster has image security policies enforced, the following repositories should be added to it.

```yaml
apiVersion: securityenforcement.admission.cloud.ibm.com/v1beta1
kind: ClusterImagePolicy
metadata:
name: sonarqube-image-policy
spec:
 repositories:
   - name: docker.io/sonarqube:*
```

Optionally include `docker.io/bitnami/postgresql:*` or `docker.io/mysql:*` if you are deploying a database with this chart.

For documentation on managing image policies refer to [Enforcing container image security](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.2/manage_images/image_security.html).

### Pod Security Policies

This chart requires the namespace being used to have the `ibm-anyuid-psp` pod security policy set on it.

## Uninstalling the chart

To uninstall/delete the deployment:

```bash
$ helm list
NAME       	REVISION	UPDATED                 	STATUS  	CHART          	NAMESPACE
kindly-newt	1       	Mon Oct  2 15:05:44 2017	DEPLOYED	sonarqube-0.1.0	default
$ helm delete kindly-newt
```

## Configuration

The following table lists the configurable parameters of the Sonarqube chart and their default values.

| Parameter                                   | Description                               | Default                                    |
| ------------------------------------------  | ----------------------------------------  | -------------------------------------------|
| `image.repository`                          | image repository                          | `sonarqube`                                |
| `image.tag`                                 | `sonarqube` image tag.                    | `7.7-community`                                        |
| `image.pullPolicy`                          | Image pull policy                         | `IfNotPresent`                             |
| `image.pullSecret`                          | imagePullSecret to use for private repository      |                                   |
| `command`                                   | command to run in the container           | `nil` (need to be set prior to 6.7.6, and 7.4)      |
| `securityContext.fsGroup`                   | Group applied to mounted directories/files|  `999`                                     |
| `ingress.enabled`                           | Flag for enabling ingress                 | false                                      |
| `ingress.annotations`                       | Ingress additional annotations            | `{}`                                       |
| `ingress.labels`                            | Ingress additional labels                 | `{}`                                       |
| `ingress.hosts[0].name`                     | Hostname to your SonarQube installation   | `sonar.organization.com`                   |
| `ingress.hosts[0].path`                     | Path within the URL structure             | /                                          |
| `livenessProbe.initialDelaySeconds`         | Initial delay in seconds for livenessProbe | 60                                        |
| `livenessProbe.periodSeconds`               | Period in seconds between probes          | 30                                         |
| `livenessProbe.sonarWebContext`             | SonarQube web context for livenessProbe   | /                                          |
| `readinessProbe.initialDelaySeconds`        | Initial delay in seconds for livenessProbe  | 60                                       |
| `readinessProbe.periodSeconds`              | Period in seconds between probes          | 30                                         |
| `readinessProbe.failureThreshold`           | Failure threshold before being marked unready  | 6                                     |
| `readinessProbe.sonarWebContext`            | SonarQube web context for readinessProbe  | /                                          |
| `service.name`                              | Kubernetes service name                   | `sonarqube`                                |
| `service.type`                              | Kubernetes service type                   | `LoadBalancer`                             |
| `service.externalPort`                      | Kubernetes service externalPort           | 9000                                       |
| `service.internalPort`                      | Kubernetes service internalPort           | 9000                                       |
| `service.labels`                            | Kubernetes service labels                 | None                                       |
| `service.annotations`                       | Kubernetes service annotations            | None                                       |
| `service.loadBalancerSourceRanges`          | Kubernetes service LB Allowed inbound IP addresses | 0.0.0.0/0                            |
| `service.loadBalancerIP`                    | Kubernetes service LB Optional fixed external IP   | None                                       |
| `persistence.enabled`                       | Flag for enabling persistent storage      | false                                      |
| `persistence.existingClaim`                 | Do not create a new PVC but use this one  | None                                       |
| `persistence.storageClass`                  | Storage class to be used                  | "-"                                        |
| `persistence.accessMode`                    | Volumes access mode to be set             | `ReadWriteMany`                            |
| `persistence.size`                          | Size of the volume                        | None                                     |
| `sonarProperties`                           | Custom `sonar.properties` file            | None                                       |
| `sonarSecretKey`                            | Name of existing secret used for settings encryption | None                            |
| `database.type`                             | Set to "mysql" to use mysql database       | `postgresql`|
| `postgresql.enabled`                        | Set to `false` to use external server / mysql database     | `true`                                     |
| `postgresql.postgresServer`                 | Hostname of the external Postgresql server| `null`                                     |
| `postgresql.postgresPasswordSecret`         | Secret containing the password of the external Postgresql server | `null`              |
| `postgresql.postgresUser`                   | Postgresql database user                  | `sonarUser`                                |
| `postgresql.postgresPassword`               | Postgresql database password              | `sonarPass`                                |
| `postgresql.postgresDatabase`               | Postgresql database name                  | `sonarDB`                                  |
| `postgresql.service.port`                   | Postgresql port                           | `5432`                                     |
| `mysql.enabled`                             | Set to `false` to use external server / postgresql database        | `false`                                     |
| `mysql.mysqlServer`                         | Hostname of the external Mysql server     | `null`                                     |
| `mysql.mysqlPasswordSecret`                 | Secret containing the password of the external Mysql server | `null`                   |
| `mysql.mysqlUser`                           | Mysql database user                       | `sonarUser`                                |
| `mysql.mysqlPassword`                       | Mysql database password                   | `sonarPass`                                |
| `mysql.mysqlDatabase`                       | Mysql database name                       | `sonarDB`                                  |
| `mysql.mysqlParams`                         | Mysql parameters for JDBC connection string     | `{}`                                 |
| `mysql.service.port`                        | Mysql port                                | `3306`                                     |
| `extraEnv`                                  | Extra env variables                       | `{}`                                       |
| `resources`                                 | Sonarqube Pod resource requests & limits  | `{}`                                       |
| `affinity`                                  | Node / Pod affinities                     | `{}`                                       |
| `nodeSelector`                              | Node labels for pod assignment            | `{}`                                       |
| `hostAliases`                               | Aliases for IPs in /etc/hosts             | `[]`                                       |
| `tolerations`                               | List of node taints to tolerate           | `[]`                                       |
| `plugins.install`                           | List of plugins to install                | `[]`                                       |
| `plugins.resources`                         | Plugin Pod resource requests & limits     | `{}`                                       |
| `plugins.initContainerImage`                | Change init container image               | `[]`                                       |
| `plugins.deleteDefaultPlugins`              | Remove default plugins and use plugins.install list | `[]`                             |
| `podLabels`                                 | Map of labels to add to the pods          | `{}`                                       |

You can also configure values for the PostgreSQL / MySQL database via the Postgresql [README.md](https://github.com/kubernetes/charts/blob/master/stable/postgresql/README.md) / MySQL [README.md](https://github.com/kubernetes/charts/blob/master/stable/mysql/README.md).

For overriding variables see: [Customizing the chart](https://docs.helm.sh/using_helm/#customizing-the-chart-before-installing).

## Persistence

The [SonarQube](https://github.com/SonarSource/docker-sonarqube) image stores its data at the `/opt/sonarqube/` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. By default, the volume is created using dynamic volume provisioning. An existing PersistentVolumeClaim can also be defined using the `persistence.existingClaim` value.

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
helm install --name my-release --set persistence.existingClaim=PVC_NAME community/sonarqube
```

## Support

To engage in the SonarQube forums, browse online documentation, or just to stay connected; please visit the [SonarQube Community page](https://www.sonarqube.org/community/).
