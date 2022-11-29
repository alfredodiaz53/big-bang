# Dev Workflow with OCI

If you want to test deployment of a package off of your dev branch you have two options. This doc covers the OCI workflow, the Git workflow requires nothing more than the values specified in [example git values](../assets/configs/example/git-repo-values.yaml) pointed to your development branch.

## Package Chart for OCI

After making your changes to a chart you will need to package it with `helm package chart`. You should see output similar to the below:

```
Successfully packaged chart and saved it to: /Users/me/bigbang/anchore/anchore-1.19.7-bb.4.tgz
```

## Pushing OCI "somewhere"

In order to use this OCI artifact you will need to push it to an OCI compatible registry. You have a couple options here.

### Push to k3d registry

The preferred option for OCI storage is in your own personal registry. When using k3d this is easy for us to handle.

1. Create your k3d cluster, using the `--registry` option to add on a registry. You will want to give this a memorable name like `bigbang-oci`. Example command `k3d cluster create --registry-create bigbang-oci ...` where `...` has the remainder of your normal k3d config. (TODO: Have this created as part of the dev script, either automatically or with a flag)

1. From your host running the k3d cluster run a `docker ps` command to locate the registry running and find the port mapping. In the example below the port is `38367`. Keep note of this port for later steps (TODO: dump this out as part of the dev script).

    ```console
    ubuntu@ip-172-31-10-94:~$ docker ps
    CONTAINER ID   IMAGE                            COMMAND                  CREATED         STATUS         PORTS                                                                                              NAMES
    fc0491f34cb5   registry:2                       "/entrypoint.sh /etc…"   5 minutes ago   Up 4 minutes   0.0.0.0:38367->5000/tcp                                                                            bigbang-oci
    ```

1. If using a remote instance (not pushing to your localhost): This is not the right way to do things but it works so why not (for now). Helm does not currently support pushing to HTTP registries, which is what k3d spins up. The correct longterm solution is probably (a) spin up a registry with the bb dev cert or (b) wait for helm support of http registries (several open issues/PRs that might accomplish this). 

    Helm will push with HTTP if pushing to localhost, so we can use this to advantage and setup routing so that `localhost` routes to our remote instance. One option is to modify `/etc/hosts` and re-route all `localhost` traffic to the remote IP. A better option is to only route traffic on a given port. This can be done with a tool like `socat`, running `socat TCP-LISTEN:<registry port>,reuseaddr,fork TCP:<remote IP>:<registry port>`. Requests to `localhost:<registry port>` will be sent to `<remote IP>:<registry port>`.

1. Push OCI artifact to this registry with `helm push <artifact name> oci://localhost:<registry port>`. Following this example that would look like this:

    ```console
    ❯ helm push anchore-1.19.7-bb.4.tgz oci://localhost:38367
    Pushed: localhost:38367/anchore:1.19.7-bb.4
    Digest: sha256:3cb826ee59fab459aa3cd723ded448fc6d7ef2d025b55142b826b33c480f0a4c
    ```

1. Configure your Big Bang values to setup an additional `HelmRepository` and point the package to that repository. See example below:

    ```yaml
    ociRepositories:
    - name: "registry1"
      repository: "oci://registry1.dso.mil/bigbang"
      existingSecret: "private-registry"
    - name: "k3d"
      repository: "oci://bigbang-oci"

    addons:
      anchore:
        oci:
          repo: "k3d"
          tag: "1.19.7-bb.4"
    ```

TBD: this doesn't work right now, maybe some docker.io implicit stuff here? test .localhost

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
