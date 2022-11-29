# Dev Workflow with OCI

If you want to test deployment of a package off of your dev branch you have two options. This doc covers the OCI workflow, the Git workflow requires nothing more than the values specified in [example git values](../assets/configs/example/git-repo-values.yaml) pointed to your development branch.

## Package Chart for OCI

After making your changes to a chart you will need to package it with `helm package chart`. You should see output similar to the below:

```
Successfully packaged chart and saved it to: /Users/me/bigbang/anchore/anchore-1.19.7-bb.4.tgz
```

## Pushing OCI "somewhere"

In order to use this OCI artifact you will need to push it to an OCI compatible registry. You have a couple options here.

### Push to Registry1 Staging

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

Issues with this approach:
- Requires access to staging, which is typically only granted to internal Big Bang team members
- Developers pushing to the same package may overwrite artifacts for the same tag
