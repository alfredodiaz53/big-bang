# Upgrading Big Bang

## Before Upgrading
Before upgrading Big Bang please first check the Release Notes and the Changelog to look for any notes that apply to Big Bang Updates and Package Updates

## Supported Upgrades
Generally we expect upgrades to be done one minor release at a time.  If necessary, it is possible to jump past several versions provided there is careful review of the release notes in between the versions and there are no problems.

NOTE: It is recommended that upgrades first be tested in a staging environment that mirrors the production environment so that errors are caught early.

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

## Upgrading Big Bang umbrella deployment
To upgrade your umbrella deployment of Big Bang when using the [Customer Template](https://repo1.dso.mil/big-bang/customers/template) :
* In the [Customer Template](https://repo1.dso.mil/big-bang/customers/template) repo in `base/kustomization.yaml` edit the value for `resources` to the next version up .

```yaml
namespace: bigbang
resources:
  - git::https://repo1.dso.mil/platform-one/big-bang/bigbang.git//base?ref=release-1.56.x
```

After this is pushed to your repo, `flux` will read the change and update all helm charts to the versions on the BB release version.

## Verifying the Upgrade
After upgrading the cluster there are some places to look to verify that the upgrade was completed successfully

### Verify Helm releases 
 - Verify all the helm releases have succeeded
```bash
❯ k get hr -A
NAMESPACE   NAME              AGE    READY   STATUS
bigbang     kyverno           5h1m   True    Release reconciliation succeeded
bigbang     kyvernopolicies   5h1m   True    Release reconciliation succeeded
bigbang     istio-operator    5h1m   True    Release reconciliation succeeded
bigbang     istio             5h1m   True    Release reconciliation succeeded
```

### Verify Pods
 - Verify that there are all pods are either `Running` or `Completed`
 - Look for any pods that recently restarted (crashing recently)
   - Below see an example of a pod that has restarted multiple times in a short time
```bash
❯ k get pod -A
NAMESPACE           NAME                                                        READY   STATUS    RESTARTS   AGE
kube-system         local-path-provisioner-5ff76fc89d-xd85h                     1/1     Running   0          22m
...
monitoring          alertmanager-monitoring-monitoring-kube-alertmanager-0      3/3     Running   7          3m
```

### Verify Image Versions for Specific Packages
 - Check for specific package versions (image version on pods ) 
   - i.e. Istio, check proxy versions
     - Below see an example of checking the image version of the running pod.
   - Runners- check for runner versions
```bash
❯ k get pod -n istio-system istiod-78c5bf85fc-68xv6 -o yaml
apiVersion: v1
kind: Pod
spec:
  affinity: {}
  containers:
  - args:
    image: registry1.dso.mil/ironbank/opensource/istio/pilot:1.17.1
...
status:
  containerStatuses:
  - containerID: containerd://451827d87a5209b4cb10ff074d986f00ec3bd7d36082cb49b8612e3a48eea9b7
    image: registry1.dso.mil/ironbank/opensource/istio/pilot:1.17.1
```
### Check Package Usability
 - Check for UI on each package

## Upgrade Troubleshooting
Troubleshooting for common issues will be added here.
