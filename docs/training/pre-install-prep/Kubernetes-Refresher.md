# Lab Overview
> In this lab we will interact with our kubernetes cluster by creating a namespace, and a pod. Next will use  
> `kubectl port-forward` to create a network connection from our laptop to the pod running in the cluster.



# Kubectl Basics

> Note: sshuttle is expecte to be running in a background  
`sshuttle -vr bastion --dns 10.10.0.0/16 --ssh-cmd 'ssh -i ~/.ssh/bb-onboarding-attendees.ssh.privatekey'`

#### Add kubectl completion
> Typing `kubectl` gets old, everyone uses a shortcuts published in the kubernetes [docs](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)  
> `bash-completion` package should be installed first
```bash
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc
source ~/.bashrc
```
> Now you can use `k` instead of typing `kubectl` and after typing 3-4 letters of the command use `tab` key to complete command  
> Test completion works:
```bash
k get dep  # <----- press tab, the word `deployments.apps` should fill in
```

#### Updating Bash on macOS
> Completion may fail with this error on macOS:
```
-bash: completion: function `__start_kubectl' not found
```
> This happens because macOS ships with Bash 3.2, and tab completion for kubectl requires a minimum Bash version of 4.1, first released in 2009. If this happens, switch to a new version of Bash:
```bash
brew install bash
echo /usr/local/bin/bash | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
```
> Then either close your terminal and open a new one, or run `exec /usr/local/bin/bash -il` if you want to stay in your existing terminal.

## Creating a Pod

1. Now that we have access to the kubernetes cluster let's deploy something

    ```bash
    kubectl create namespace refresher
    kubectl get namespaces
    kubectl get ns
    ```

2. Quick exercise to build some background docker knowledge:

        Note:
        docker.io is an implicit default that gets put in front of images
        so iahmad/ubi8-nginx-high-port:8.1
        is actually docker.io/iahmad/ubi8-nginx-high-port:8.1
        Try running in terminal:
    ```bash
    docker pull docker.io/iahmad/ubi8-nginx-high-port:8.1
    # Downloading...

    # Then
    docker pull iahmad/ubi8-nginx-high-port:8.1
    # ... Image is up to date ...
    # (This knowledge will be important for future Open Policy Agent Image Registry Filtering Constraints)
    ```

3. Create a folder to work in:

    ```bash
    mkdir -p ~/day1refresher
    cd ~/day1refresher
    ```

4. Copy and paste the contents into a file

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: simple-nginx-app
      namespace: refresher
    spec:
      containers:
      - name: simple-nginx-app
        image: iahmad/ubi8-nginx-high-port:8.1
        ports:
        - containerPort: 7000 # This correlates to the port in the nginx.conf
    ```

    ```bash
    vi pod.yml
    # Press i for insert mode, then Paste
    # escape : qw! Enter to save
    cat pod.yml
    # Verify the file saved correctly/looks right
    ```

5. Run the following command to deploy the pod into the cluster

    ```bash
    kubectl apply -f pod.yml
    ```

6. Validate the pod deployed correctly

    ```bash
    kubectl get pods -n refresher
    ```

    **RECORD your pod-name**

7. Open another terminal and run the following command:

    ```bash
    kubectl port-forward <your-pod-name> 8080:7000 --namespace=refresher
    # the 8080:7000 in the command means your laptop's
    # localhost:8080 --redirects to--> pod's port 7000
    ```

    **Note:** The above command will not return you your terminal prompt, until you `ctrl+c`

8. In a new terminal window: Use the `curl` command to reach the following URL from your Laptop:

    ```bash
    curl localhost:8080
    ```

    **Note:** kubectl port-forward will crash after ~1-3 minutes, so if you're slow on the above command you may need to rerun the port forward

9. Once you've been able to hit your application delete your pod

    ```bash
    # You can go back to the original terminal that was running the kubectl port-forward command and use Ctrl + C to break out of it.
    cd ~/day1refresher
    kubectl delete -f pod.yml
    ```

### Lab Summary

You have been able to create a pod that deploys an instance of an nginx container inside your pod. You also used the `kubectl port-forward` command, a debug tool, to open a port on your server to a port on the nginx pod in the cluster. You then used this tunnel to send a `curl` command to the pod and validate your pod is up and running, and accepting traffic over this tunnel.

## More Refresher Links

[Kubernetes Refresher](https://repo1.dso.mil/big-bang/customer-training/bigbang-training/-/blob/initial-docs-porting/legacyDocSources/fromOnboardingPage/engineering-cohort/slides/Day%201%20-%20Module%202_%20Kubernetes%20Refresher.pdf)

[Kubernetes Package Managers](https://repo1.dso.mil/big-bang/customer-training/bigbang-training/-/blob/initial-docs-porting/legacyDocSources/fromOnboardingPage/engineering-cohort/slides/Day%201%20-%20Module%203_%20Kubernetes%20Package%20Managers.pdf)