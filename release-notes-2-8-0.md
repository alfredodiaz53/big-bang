# Release Notes - 2.8.0

Please see our [documentation](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/tree/2.8.0) page for more information on how to consume and deploy BigBang. This release was primarily tested on Kubernetes 1.26.3 (RKE2).

## Upgrade Notices

> Add any upgrade notices from the release issue here. You may also want to
> reach out to package maintainers for anything that looks like a major change.
> Changelog diffs for packages are included below in the `## Changes in 2.8.0`
> which may be helpful to identify "major chanes".

### **Upgrades from previous releases**

If coming from a version pre-`2.7.1`, note the additional upgrade notices in any release in between. The BB team doesn't test/guarantee upgrades from anything pre-`2.7.1`.

## Packages

| Package                                                                                                                                                                                                                     | Type   | Package Version                                                | BB Version                              |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|----------------------------------------------------------------|-----------------------------------------|
| [Istio Controlplane](https://repo1.dso.mil/big-bang/product/packages/istio-controlplane)                                                                                                                                    | Core   | Istio `1.18.1` Tetrate Istio Distro `1.18.0`                   | `1.18.1-bb.0`                           |
| [Istio Operator](https://repo1.dso.mil/big-bang/product/packages/istio-operator)                                                                                                                                            | Core   | Istio Operator `1.18.1` Tetrate Istio Distro Operator `1.18.0` | `1.18.1-bb.0`                           |
| [Jaeger](https://repo1.dso.mil/big-bang/product/packages/jaeger)                                                                                                                                                            | Core   | `1.46.0`                                                       | `2.46.0-bb.0`                           |
| [Kiali](https://repo1.dso.mil/big-bang/product/packages/kiali)                                                                                                                                                              | Core   | `1.71.0`                                                       | `1.71.0-bb.1`                           |
| [Cluster Auditor](https://repo1.dso.mil/big-bang/product/packages/cluster-auditor)                                                                                                                                          | Core   | `0.0.7`                                                        | `1.5.0-bb.4`                            |
| [Gatekeeper](https://repo1.dso.mil/big-bang/product/packages/policy)                                                                                                                                                        | Core   | `3.12.0`                                                       | `3.12.0-bb.4`                           |
| [Kyverno](https://repo1.dso.mil/big-bang/product/packages/kyverno)                                                                                                                                                          | Core   | `1.9.2`                                                        | `2.7.2-bb.0`                            |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Kyverno Policies](https://repo1.dso.mil/big-bang/product/packages/kyverno-policies)                                                       | Core   | `1.1.0`                                                        | `1.1.0-bb.9` [🔗](#kyverno-policies)    |
| [Kyverno Reporter](https://repo1.dso.mil/big-bang/product/packages/kyverno-reporter)                                                                                                                                        | Core   | `2.10.4`                                                       | `2.16.0-bb.1`                           |
| [Elasticsearch Kibana](https://repo1.dso.mil/big-bang/product/packages/elasticsearch-kibana)                                                                                                                                | Core   | Kibana `8.7.1` Elasticsearch `8.7.0`                           | `1.3.1-bb.0`                            |
| [Eck Operator](https://repo1.dso.mil/big-bang/product/packages/eck-operator)                                                                                                                                                | Core   | `2.8.0`                                                        | `2.8.0-bb.0`                            |
| [Fluentbit](https://repo1.dso.mil/big-bang/product/packages/fluentbit)                                                                                                                                                      | Core   | `2.1.4`                                                        | `0.30.4-bb.0`                           |
| [Promtail](https://repo1.dso.mil/big-bang/product/packages/promtail)                                                                                                                                                        | Core   | `2.8.2`                                                        | `6.11.3-bb.0`                           |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Loki](https://repo1.dso.mil/big-bang/product/packages/loki)                                                                               | Core   | `2.8.3`                                                        | `5.9.2-bb.0` [🔗](#loki)                |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Neuvector](https://repo1.dso.mil/big-bang/product/packages/neuvector) ![BETA](https://img.shields.io/badge/BETA-purple?style=flat-square) | Core   | `5.1.3`                                                        | `2.4.5-bb.2` [🔗](#neuvector)           |
| [Tempo](https://repo1.dso.mil/big-bang/product/packages/tempo)                                                                                                                                                              | Core   | Tempo `2.1.1` Tempo Query `2.1.1`                              | `1.2.0-bb.2`                            |
| [Monitoring](https://repo1.dso.mil/big-bang/product/packages/monitoring)                                                                                                                                                    | Core   | Prometheus `2.45.0` Grafana `10.0.1` Alertmanager `0.25.0`     | `47.1.0-bb.1`                           |
| [Grafana](https://repo1.dso.mil/big-bang/apps/sandbox/grafana)                                                                                                                                                              | Core   | N / A                                                          | `6.57.4-bb.0`                           |
| [Twistlock](https://repo1.dso.mil/big-bang/product/packages/twistlock)                                                                                                                                                      | Core   | `22.12.415`                                                    | `0.12.0-bb.4`                           |
| [Wrapper](https://repo1.dso.mil/big-bang/product/packages/wrapper)                                                                                                                                                          | Core   | N / A                                                          | `0.4.1`                                 |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Argocd](https://repo1.dso.mil/big-bang/product/packages/argocd)                                                                           | Addon  | `2.7.7`                                                        | `5.39.0-bb.0` [🔗](#argocd)             |
| [Authservice](https://repo1.dso.mil/big-bang/product/packages/authservice)                                                                                                                                                  | Addon  | `0.5.3`                                                        | `0.5.3-bb.11`                           |
| [Minio Operator](https://repo1.dso.mil/big-bang/product/packages/minio-operator)                                                                                                                                            | Addon  | `5.0.5`                                                        | `5.0.5-bb.0`                            |
| [Minio](https://repo1.dso.mil/big-bang/product/packages/minio)                                                                                                                                                              | Addon  | `RELEASE.2023-06-19T19-52-50Z`                                 | `5.0.5-bb.0`                            |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Gitlab](https://repo1.dso.mil/big-bang/product/packages/gitlab)                                                                           | Addon  | `16.2.0`                                                       | `7.2.0-bb.0` [🔗](#gitlab)              |
| [Gitlab Runner](https://repo1.dso.mil/big-bang/product/packages/gitlab-runner)                                                                                                                                              | Addon  | `15.11.0`                                                      | `0.52.0-bb.1`                           |
| [Nexus](https://repo1.dso.mil/big-bang/product/packages/nexus)                                                                                                                                                              | Addon  | `3.53.1-02`                                                    | `53.1.0-bb.1`                           |
| [Sonarqube](https://repo1.dso.mil/big-bang/product/packages/sonarqube)                                                                                                                                                      | Addon  | `9.9.1-community`                                              | `8.0.1-bb.2`                            |
| [Haproxy](https://repo1.dso.mil/big-bang/product/packages/haproxy)                                                                                                                                                          | Addon  | `2.2.21`                                                       | `1.12.0-bb.0`                           |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Anchore Enterprise](https://repo1.dso.mil/big-bang/product/packages/anchore-enterprise)                                                   | Addon  | Enterprise `4.8.0` Engine `1.1.0`                              | `1.26.1-bb.0` [🔗](#anchore-enterprise) |
| [Mattermost Operator](https://repo1.dso.mil/big-bang/product/packages/mattermost-operator)                                                                                                                                  | Addon  | `1.20.1`                                                       | `1.20.1-bb.0`                           |
| [Mattermost](https://repo1.dso.mil/big-bang/product/packages/mattermost)                                                                                                                                                    | Addon  | `7.10.5`                                                       | `7.10.5-bb.0`                           |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Velero](https://repo1.dso.mil/big-bang/product/packages/velero)                                                                           | Addon  | `1.11.0`                                                       | `4.0.3-bb.0` [🔗](#velero)              |
| [Keycloak](https://repo1.dso.mil/big-bang/product/packages/keycloak)                                                                                                                                                        | Addon  | `21.1.1`                                                       | `18.4.3-bb.2`                           |
| [Vault](https://repo1.dso.mil/big-bang/product/packages/vault)                                                                                                                                                              | Addon  | `1.13.1`                                                       | `0.24.1-bb.1`                           |
| [Metrics Server](https://repo1.dso.mil/big-bang/product/packages/metrics-server)                                                                                                                                            | Addon  | `0.6.3`                                                        | `3.10.0-bb.0`                           |
| ![Updated](https://img.shields.io/badge/Updated-informational?style=flat-square) [Harbor](https://repo1.dso.mil/platform-one/big-bang/apps/sandbox/harbor)                                                                  | Addon  | `2.8.2`                                                        | `1.12.2-bb.7` [🔗](#harbor)             |

## Changes in 2.8.0

### Big Bang MRs

> Parsing this MR list programatically has no guarantee to be accurate
> due to the nonstandard format of labeling our MRs.
> 
> Because of this, you will have to break out this list manually,
> and move each MR under the package it belongs to / deals with.
> Leave any non-package specific MRs here.

- [!2975](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2975): promtail update to 6.13.1-bb.0
- [!2974](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2974): authservice update to 0.5.3-bb.12
- [!2972](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2972): istio & operator update to 1.18.2-bb.0
- [!2973](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2973): gitlab update to 7.2.0-bb.0
- [!2971](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2971): Grafana chart indentation 6 -> 4
- [!2963](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2963): kyvernoPolicies update to 1.1.0-bb.9
- [!2964](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2964): neuvector update to 2.4.5-bb.2
- [!2966](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2966): loki update to 5.9.2-bb.0
- [!2930](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2930): Re-add IB key to Kyverno Policies test-values
- [!2950](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2950): velero update to 4.0.3-bb.0
- [!2936](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2936): argocd update to 5.39.0-bb.0
- [!2957](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2957): fix for ca-secret creation logic
- [!2938](https://repo1.dso.mil/big-bang/bigbang/-/merge_requests/2938): Add 'comments' field to schema


### Kyverno Policies

```markdown
# Changelog Updates

## [1.1.0-bb.9] - 2023-08-01
### Added
- added DEVELOPMENT_MAINTENANCE.md

## [1.1.0-bb.8] - 2023-07-27
### Changed
- re-added IB key to test values for package/BB CI
- modified disallow-image-tags, require-image-signature, update-image-registry
- added timeout to test-policies.sh
```


### Loki

```markdown
# Changelog Updates

## [5.9.2-bb.0] - 2023-08-03
### Changed
- Updated to latest upstream chart 5.9.2
```


### Neuvector

```markdown
# Changelog Updates

## [2.4.5-bb.2] - 2023-07-31
### Fixed
- OSCAL component file package reference

## [2.4.5-bb.1] - 2023-07-27
### Added
- OSCAL component file
```


### Argocd

```markdown
# Changelog Updates

## [5.39.0-bb.0] - 2023-07-14
### Updated
- Updated to Argo 2.7.7
- Updated to dex 2.37.0
- Updated to redis 7.0.12
```


### Gitlab

```markdown
# Changelog Updates

## [7.2.0-bb.0] - 2023-07-28
### Changed
- ironbank/gitlab/gitlab/gitlab-webservice  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/certificates  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitaly  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-container-registry  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-exporter  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-mailroom  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-pages  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-shell  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-sidekiq  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-toolbox  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-webservice  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-workhorse  16.1.2 -> 16.2.0
- registry1.dso.mil/ironbank/gitlab/gitlab/kubectl  16.1.2 -> 16.2.0
```


### Anchore Enterprise

```markdown
# Changelog Updates

## [1.26.1-bb.0]
### Changed
- Bumped chart version to `1.26.1`
- Bumped Anchore Enterprise image tag to `4.8.0`
- Bumped Anchore Enterprise UI image tag to `4.8.0`
```


### Velero

```markdown
# Changelog Updates

## [4.0.3-bb.0]
### Changed
- registry1.dso.mil/ironbank/opensource/velero/velero v1.10.2 -> v1.11.0
- registry1.dso.mil/ironbank/opensource/velero/velero 1.10.2 -> 1.11.0
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-aws v1.6.1 -> v1.7.0
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-csi v0.4.2 -> v0.5.0
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-microsoft-azure v1.6.1 -> v1.7.0
- velero/velero-plugin-for-aws v1.6.1 -> v1.7.0
- velero/velero-plugin-for-csi v0.4.2 -> v0.5.0
- velero/velero-restore-helper v1.10.2 -> v1.11.0

## [3.1.5-bb.1]
### Changed
- registry1.dso.mil/ironbank/opensource/kubernetes/kubectl patch v1.26.3 -> v1.26.4

## [3.1.5-bb.0]
### Changed
- registry1.dso.mil/ironbank/opensource/kubernetes/kubectl patch v1.26.2 -> v1.26.3
- registry1.dso.mil/ironbank/opensource/velero/velero patch v1.10.1 -> v1.10.2
- registry1.dso.mil/ironbank/opensource/velero/velero patch 1.10.1 -> 1.10.2
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-csi patch v0.4.1 -> v0.4.2
- velero/velero-plugin-for-csi patch v0.4.1 -> v0.4.2
- velero/velero-restore-helper patch v1.10.1 -> v1.10.2

## [3.1.2-bb.2]
### Changed
- Updated nginx to `1.23.3` and kubectl to `1.26.2`

## [3.1.2-bb.1]
### Changed
- Fixed mismatch between volume and mount for caCert

## [3.1.2-bb.0]
### Changed
- registry1.dso.mil/ironbank/opensource/kubernetes/kubectl minor v1.25.6 -> v1.26.1
- registry1.dso.mil/ironbank/opensource/velero/velero patch v1.10.0 -> v1.10.1
- registry1.dso.mil/ironbank/opensource/velero/velero patch 1.10.0 -> 1.10.1
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-aws patch v1.6.0 -> v1.6.1
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-csi patch v0.4.0 -> v0.4.1
- registry1.dso.mil/ironbank/opensource/velero/velero-plugin-for-microsoft-azure patch v1.6.0 -> v1.6.1
- velero/velero-plugin-for-aws patch v1.6.0 -> v1.6.1
- velero/velero-plugin-for-csi patch v0.4.0 -> v0.4.1
- velero/velero-restore-helper patch v1.10.0 -> v1.10.1

## [3.1.0-bb.3]
### Changed
- Updated kubectl to `1.25.6`

## [3.1.0-bb.2]
### Changed
- Added aws, azure, and csi plugin configuration options

## [3.1.0-bb.1]
### Changed
- Switch tester image to bigbang-ci source

## [3.1.0-bb.0]
### Changed
- Updated to latest chart version `3.1.0` (support for 1.10.0)

## [2.32.5-bb.0]
### Update
- Updated velero to `1.10.0`, upstream chart version `velero-2.32.5`, nginx to `1.23.2`, kubectl to `1.25.5`, and azure plugin to `1.6.0`

## [2.32.2-bb.0]
### Update
- Updated velero to `1.9.3`, upstream chart version `velero-2.32.2`, kubectl to `1.25.4`, and azure plugin to `1.5.2`

## [2.31.8-bb.5]
### Changed
- Added prometheusRule alerts for common velero failures

## [2.31.8-bb.4]
### Changed
- Added helm annotations for images in use

## [2.31.8-bb.3]
### Update
- updated velero plugins to latest IB versions

## [2.31.8-bb.2]
### Fixed
- Fixed `VolumeSnapshotContent` CRD name for capabilities check

## [2.31.8-bb.1]
### Changed
- Added capabilities check for CRDs on csi-snapshot-class

## [2.31.8-bb.0]
### Changed
- Updated to latest chart 2.31.8
- Updated velero to 1.9.2

## [2.31.3-bb.2]
### Added
- Added support for tlsConfig and scheme values in the serviceMonitor

### Removed
- Removed mTLS exception for metrics

## [2.31.3-bb.1]
### Changed
- Enabled drop all capabilities
- Updated gluon to 0.3.0

## [2.31.3-bb.0]
### Changed
- Updated to latest chart 2.31.3
- Updated velero to 1.9.1

## [2.30.1-bb.2]
### Added
- Added Grafana dasboard JSON & ConfigMap
- Original dashboard sourced from: https://grafana.com/grafana/dashboards/11055-kubernetes-addons-velero-stats which has been modified/updated to use non-deprecated metrics APIs. Hence, included version is not publicly available from any source as it is an adaptation.

## [2.30.1-bb.1]
### Fixed
- API version for CSI snapshot class updated to v1

## [2.30.1-bb.0]
### Updated
- KPT'd to upstream `velero-2.30.1`
- Updated velero to 1.9.0
- Updated plugins

## [2.29.0-bb.4]
### Changed
- set the runAsUser/runAsGroup to 65534/65534 -- this is the default for the kyverno docker image.
- set host_pods restic mount to read-only.

## [2.29.0-bb.3]
### Added
- OSCAL UUID updates

## [2.29.0-bb.2]
### Added
- OSCAL Document for NIST 800-53

## [2.29.0-bb.1]
### Updated
- Added Tempo Zipkin Egress Policy

## [2.29.0-bb.0]
### Updated
- Bumped chart version to 2.29.0
- Bumped Velero image tag to v1.8.1
- Bumped Velero aws image tag to v1.4.1
- Bumped Velero azure image tag to v1.4.1
- Bumped Velero helper image tag to v1.8.1

## [2.28.0-bb.1]
### Added
- Add default PeerAuthentication to enable STRICT mTLS

## [2.28.0-bb.0]
### Updated
- Bumped chart version to 2.28.0
- Bumped Velero image tag to v1.8.0
- Bumped Velero aws image tag to v1.4.0
- Bumped Velero azure image tag to v1.4.0
- Bumped Velero helper image tag to v1.8.0

## [2.27.3-bb.3]
### Updated
- Updates for bb helm tests

## [2.27.3-bb.2]
### Updated
- Updated kubectl image repository to point to registry1.dso.mil/ironbank/opensource/kubernetes
- Updated kubectl version to 1.22.2

## [2.27.3-bb.1]
### Updated
- Update Chart.yaml to follow new standardization for release automation
- Added renovate check to update new standardization

## [2.27.3-bb.0]
### Changed
- Updated to Velero 1.7.1 and latest helm chart

## [2.23.6-bb.4]
### Changed
- relocated bbtests

## [2.23.6-bb.3]
### Added
- modify tests to look only in velero NS
- updated images in tests for:

## [2.23.6-bb.2]
### Added
- Added VolumeSnapshotClass if CSI plugin is enabled

## [2.23.6-bb.1]
### Changed
- Moved testing to gluon library

## [2.23.6-bb.0]
### Added
- bumped registry1 velero image tag to 1.6.3
- bumped upstream chart to velero-2.23.6

## [2.23.5-bb.1]
### Added
- Added resource limits and requests to upgrade and cleanup jobs
- Set requests and limits equal to each other
- Added resources to test-values initContainer

## [2.23.5-bb.0]
### Updated
- bumped registry1 velero image tag to 1.6.2
- Updated upstream chart to velero-2.23.5

## [2.23.3-bb.0]
### Updated
- bumped Registry1 Velero image tag to 1.6.1

### Added
- Velero plugin for CSI

## [2.21.1-bb.6]
### Added
- Bigbang network policy to allow prometheus scraping of istio envoy sidecar
- monitoring.enabled to values and scraping net policies to stay in line with bigbang standards

## [2.21.1-bb.5]
### Added
- Helm function in API Egress Network Policy Template to avoid crashes when non 0.0.0.0/0 CIDR is specified

## [2.21.1-bb.4]
### Fixed
- Turned off sidecars for jobs
- Fixed NPs that were blocking job API access

## [2.21.1-bb.3]
### Added
- ENV for Azure CA Bundle trusting

## [2.21.1-bb.2]
### Added
- Trusting of custom CA bundle cert for AWS (secret creation, volume mounting, env setup)
- Note: May only work on AWS due to env name and available upstream docs surrounding this

## [2.21.1-bb.1]
### Added
- Added Optional network policies

## [2.21.1-bb.0]
### Updated
- realigned Helm chart to use `.Values.initContainers` like upstream chart
- bumped Registry1 Velero image tag to 1.6.0

## [2.14.8-bb.0]
### Added
- added initial tag for Velero
- added CI testing using Helm library and bash script
```


### Harbor

```markdown
# Changelog Updates

## [1.12.2-bb.7] - 2023-07-31
### Removed
- `bigbang/` integration CI only folder and templates.
```


## Known Issues

> Known issues not found for previous release. Manually add any known issues or delete this section


## Helpful Links

As always, we welcome and appreciate feedback from our community of users. Please feel free to:

- [Open issues here](https://repo1.dso.mil/platform-one/big-bang/umbrella/-/issues/new?issue%5Bassignee_id%5D=&issue%5Bmilestone_id%5D=)
- [Join our chat](https://chat.il2.dso.mil/platform-one/channels/team---big-bang)
- Check out the [documentation](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/tree/master/docs) for guidance on how to get started

## Future

Don't see your feature and/or bug fix? Check out our [epics](https://repo1.dso.mil/groups/platform-one/big-bang/-/epic_boards/7) for estimates on when you can expect things to drop, and as always, feel free to comment or create issues if you have questions, comments, or concerns.