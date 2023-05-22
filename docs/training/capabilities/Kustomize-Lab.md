# Kustomize Lab

## Lab Overview
> In this lab we use `kustomize` CLI tool for templating kubernetes `.yaml` files, but first we will build out the directory structure and populate the necessary files.  
> Finally we will compare the files that the `kustomize` tool generated to understand how `kustomize` is implemented 



# [Kustomize](https://kustomize.io/)

## Lab

1. Verify kustomize is installed

    ```bash
    kustomize version
    which kustomize
    ```
    > NOTE for Ubuntu users (if kustomize was installed via snap you'll see errors, so let's verify  
   >  The which command tells you the path where the kustomize cli tool is installed,
   >  if you see snap in the path, uninstall it and reinstall using the directions on [this](https://repo1.dso.mil/platform-one/onboarding/big-bang/engineering-cohort/-/blob/master/lab_guides/01-Preflight-Access-Checks/01-software-check.md#kustomize) page

2. Create the file structure

    ```bash
    cd ~/Desktop/configlabs
    mkdir -p sample-app/base
    mkdir -p sample-app/overlays/development
    mkdir -p sample-app/overlays/production
    ```

3. Create the base deployment yaml and open to edit

    ```bash
    vi sample-app/base/deployment.yaml
    ```

4. Add base pod to the file and save

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-world
    spec:
      replicas: 1
      selector:
        matchLabels:
         app: hello-world
      template:
        metadata:
          labels:
            app: hello-world
        spec:
          containers:
          - name: hello-world
            image: nginx
            resources:
              limits:
                memory: "128Mi"
                cpu: "500m"
            ports:
            - containerPort: 80
    ```

5. Create the base kustomization.yaml and open to edit

    ```bash
    vi sample-app/base/kustomization.yaml
    ```

6. Add the following contents and save

    ```yaml
    # Specifies the files to include when kustomize builds the application
    resources:
    - deployment.yaml
    ```

    Create an overlay file and open to edit

    ```bash
    vi sample-app/overlays/development/replica_count.yaml
    ```

7. Add the following contents and save

    ```yaml
    # Overlay to increase the replicaCount
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-world
    spec:
      replicas: 3
    ```

8. Create an overlay kustomization file and open to edit

    ```bash
    vi sample-app/overlays/development/kustomization.yaml
    ```

9. Add the following contents

    ```yaml
    # Specifies the base files
    bases:
    - ../../base

    # Specifies overrides to the base files
    patches:
    - replica_count.yaml
    ```

10. Generate Kustomize output

    ```bash
    kustomize build sample-app/overlays/development 
    cat sample-app/base/deployment.yaml
    ```

    Compare the 2 outputs and notice the replicaCount of 3 was overlaid onto the base file


# Bonus round!

11. Generate a production deployment with kustomize
    
    Create the `kustomization.yaml` and `replica_count.yaml` for production environment
    
    ```bash
    vi sample-app/overlays/production/kustomization.yaml
    ```
    Add the following contents
    ```yaml
    bases:
    - ../../base
    
    patches:
    - replica_count.yaml
    ```
    
    ```bash
    vi sample-app/overlays/production/replica_count.yaml
    ```
    Add the following contents
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-world
    spec:
      replicas: 200
    ```

### Now create the deployment file for our production environment 
12.     
    ```bash
    kustomize build sample-app/overlays/production
    ```
    This should spit the following out to the terminal:
    
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-world
    spec:
      replicas: 200
      selector:
        matchLabels:
          app: hello-world
      template:
        metadata:
          labels:
            app: hello-world
        spec:
          containers:
          - image: nginx
            name: hello-world
            ports:
            - containerPort: 80
            resources:
              limits:
                cpu: 500m
                memory: 128Mi
    ```