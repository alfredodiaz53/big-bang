# Environment validation

Istio is installed as part of Big Bang's helm chart values. After setting up the environment as described in the Big Bang Quickstart, let's validate the functionality of the Istio installation.

## Verify that Istio is installed

1. List Kubernetes namespaces and note the new namespace `istio-system`.

    ```{.shell .language-shell}
    kubectl get ns
    ```

1. Verify that the `istiod` controller pod is running in that namespace.

    ```{.shell .language-shell}
    kubectl get pod -n istio-system
    ```

## Add `istioctl` to your PATH

The recommended tool for interacting with Istio over the command line is `istioctl`. Let's download an Istio distribution to install the CLI tool:

1. Run the following command from your home directory.

    ```{.shell .language-shell}
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION={{istio.version}} sh -
    ```

1. Navigate into the directory created by the above command.

    ```{.shell .language-shell}
    cd istio-{{istio.version}}
    ```

The `istioctl` CLI is located in the `bin/` subdirectory.

1. Create a `bin` subdirectory in your home directory:

    ```{.shell .language-shell}
    mkdir ~/bin
    ```

1. Copy the CLI to that subdirectory:

    ```{.shell .language-shell}
    cp ./bin/istioctl ~/bin
    ```

1. Add your home `bin` subdirectory to your `PATH`.

    ```shell
    cat << EOF >> ~/.bashrc

    export PATH="~/bin:\$PATH"

    EOF
    ```

    Then:

    ```shell
    source ~/.bashrc
    ```

Verify that `istioctl` is installed with:

```{.shell .language-shell}
istioctl version
```

1. Run `istioctl version`.  The output should include a _control plane_ version, indicating Istio is indeed present in the cluster.

## Artifacts

The lab instructions reference Kubernetes yaml artifacts that you will need to apply to your cluster at specific points in time.

You can copy and paste the yaml snippets directly from the lab instructions as you encounter them.

Another option is to clone the [repository for this documentation](https://repo1.dso.mil/big-bang/bigbang){target=_blank} and extract the artifacts.

```shell
git clone https://repo1.dso.mil/big-bang/bigbang && \
  mv docs/training/istio/artifacts . && \
  rm -rf big-bang
```

**Important tip**

This workshop makes extensive use of the `kubectl` CLI.

Consider configuring an alias to make typing slightly easier.

    ```shell
    cat << EOF >> ~/.bashrc

    source <(kubectl completion bash)
    alias k=kubectl
    complete -F __start_kubectl k

    EOF

    source ~/.bashrc
    ```


## Next

With Istio installed and a proper environment, we are ready to dive deep into Istio's architecture.
