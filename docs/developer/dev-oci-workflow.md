# Dev Workflow with OCI

⚠️ **NOTE: This doc is a work in progress as OCI is not the expected or default workflow in Big Bang yet. Changes might be made to the structure or process at any time.** ⚠️

If you want to test deployment of a package off of your dev branch you have two options. This doc covers the OCI workflow, the Git workflow requires nothing more than the values specified in [example git values](../assets/configs/example/git-repo-values.yaml) pointed to your development branch.

## Package Chart for OCI

After making your changes to a chart you will need to package it with `helm package chart`. You should see output similar to the below:

```console
Successfully packaged chart and saved it to: /Users/me/bigbang/anchore/anchore-1.19.7-bb.4.tgz
```

Note that Helm strictly enforces the OCI name and tag to match the chart name and version (see [HIP 0006](https://github.com/helm/community/blob/main/hips/hip-0006.md#3-chart-versions--oci-reference-tags)), and artifacts will always match the above syntax.

## Pushing OCI "somewhere"

In order to use this OCI artifact you will need to push it to an OCI compatible registry. You have a couple options here.

### Push to k3d registry

The preferred option for OCI storage is in your own personal registry. When using k3d this is easy for us to handle.

1. Create a registry using k3d commands. You will want to create this on the same host as your k3d cluster (i.e. your ec2 instance if using a dev ec2 instance). Give it a memorable name (`oci`) and standard port mapping. (TODO: Have this created as part of the dev script, either automatically or with a flag)

    ```console
    k3d registry create oci --port 5000
    ```

2. Create your k3d cluster, using the `--registry-use` option to reference your registry. Note that k3d adds the `k3d-` prefix to the registry. An example command is below, following the naming and port mapping from this example. (TODO: Have this added as part of the dev script, either automatically or with a flag)

    ```console
    k3d cluster create --registry-use k3d-oci:5000
    ```

3. If running the cluster on your localhost (dev machine = cluster machine), skip this step. If your cluster is running on an ec2 instance or other remote machine, you will want to add the hostname to your `/etc/hosts` file so that your machine can resolve it properly. See the below example where the remote instance IP is 1.2.3.4:

    ```console
    # Add this line to /etc/hosts
    1.2.3.4 k3d-oci
    ```

    To validate this is setup correctly, curl the registry catalog:

    ```console
    ❯ curl k3d-oci:5000/v2/_catalog
    {"repositories":[]}
    ```

4. Push OCI artifact to this registry with `helm push <artifact name> oci://k3d-oci:5000`. Following this example that would look like this:

    ```console
    ❯ helm push anchore-1.19.7-bb.4.tgz oci://k3d-oci:5000
    Pushed: localhost:38367/anchore:1.19.7-bb.4
    Digest: sha256:3cb826ee59fab459aa3cd723ded448fc6d7ef2d025b55142b826b33c480f0a4c
    ```

5. Configure your Big Bang values to setup an additional `HelmRepository` and point the package to that repository. See example below:

    ```yaml
    ociRepositories:
    - name: "registry1"
      repository: "oci://registry1.dso.mil/bigbang"
      existingSecret: "private-registry"
    - name: "k3d"
      repository: "oci://k3d-oci:5000"

    addons:
      anchore:
        oci:
          repo: "k3d"
          tag: "1.19.7-bb.4"
    ```

### Push to Registry1 Staging

One option is to push your OCI artifacts to the Big Bang Staging area of Registry1. This is a SHARED area that internal Big Bang team members have access to - note that you may overwrite other developer's artifacts if you take this approach.

1. Login to registry1 with helm: `helm registry login registry1.dso.mil`. Follow the prompts to add your normal username and CLI token for registry1 auth.

    ```console
    ❯ helm registry login registry1.dso.mil
    Username: myusername
    Password: 
    Login Succeeded
    ```

1. Push OCI artifact to the staging area with `helm push <artifact name> oci://registry1.dso.mil/bigbang-staging`.

    ```console
    ❯ helm push anchore-1.19.7-bb.4.tgz oci://registry1.dso.mil/bigbang-staging
    Pushed: registry1.dso.mil/bigbang-staging/anchore:1.19.7-bb.4
    Digest: sha256:3cb826ee59fab459aa3cd723ded448fc6d7ef2d025b55142b826b33c480f0a4c
    ```

1. Configure your Big Bang values to setup an additional `HelmRepository` and point the package to that repository. See example below:

    ```yaml
    ociRepositories:
    - name: "registry1"
      repository: "oci://registry1.dso.mil/bigbang"
      existingSecret: "private-registry"
    - name: "staging"
      repository: "oci://registry1.dso.mil/bigbang-staging"
      existingSecret: "private-registry"
    
    addons:
      anchore:
        oci:
          repo: "staging"
          tag: "1.19.7-bb.4"
    ```
