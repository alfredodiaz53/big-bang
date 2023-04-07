# Upgrading Big Bang

## Upgrading a Single Package
Packages in Big Bang can be updated one at a time
Upgrading a single package in Big Bang is done by changing the tag in the values for that package.  This should be done in the overriding valus in the customer template.

For a git repository:
```yaml
  git:
    repo: https://repo1.dso.mil/platform-one/big-bang/apps/core/istio-controlplane.git
    path: "./chart"
    tag: "1.17.1-bb.0"
```
For OCI:
```yaml
istio:
  git: null
  oci:
    name: "istio"
    tag: "1.15.3-bb.0"
    repo: "registry1"
```
These values are in `chart/values.yaml` of the Big Bang helm chart.
When using the [Customer Template](https://repo1.dso.mil/big-bang/customers/template) you can make these changes in either the `bigbang/base/values.yaml` or in each cluster's kustomizations (`bigbang/dev/values.yaml)`.



*** release notes review for individual packages + upstream review for breaking changes.

        

## Upgrading Big Bang umbrella deployment
To upgrade your umbrella deployment of Big Bang when using the [Customer Template](https://repo1.dso.mil/big-bang/customers/template) :
* In the [Customer Template](https://repo1.dso.mil/big-bang/customers/template) repo in `base/kustomization.yaml` edit the value for `resources` to the next version up .

```yaml
namespace: bigbang
resources:
  - git::https://repo1.dso.mil/platform-one/big-bang/bigbang.git//base?ref=release-1.56.x
```
After this is pushed to your repo, `flux` will read the change and update all helm charts to the versions on the BB release version.

***How to upgrade BB umbrella: Review of release notes for any upgrade notices, known issues, etc. What does an actual code change look like to upgrade (focus on customer template usage).

## Verifying the Upgrade


***How to know your upgrade "worked": What to look for in cluster to validate that Big Bang has upgraded and is healthy

## Supported Upgrades
Generally we expect upgrades to be done one minor release at a time.  If necessary, it is possible to jump past several versions provided there is careful review of the release notes in between the versions and there are no problems.

NOTE: It is recommended that upgrades first be tested in a staging environment that mirrors the production environment so that errors are caught early.
