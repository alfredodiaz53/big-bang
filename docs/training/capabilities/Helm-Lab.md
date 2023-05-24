# Helm Lab

## Lab Overview
> In this lab we will install Helm CLI tool, add helm repository, use `helm` CLI tool to template kubernetes `.yaml` files.

# Helm Templating

## Templating a chart

1. Install the Helm CLI

   ```bash
   mkdir -p ~/Desktop/configlabs
   cd ~/Desktop/configlabs
   curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

   ```

2. Add a helm chart repository

   ```bash
   helm repo add oteemocharts https://oteemo.github.io/charts
   ```

3. Update your local helm repositories

   ```bash
   helm repo update
   ```

4. Template out to a single file  
     verify that you are in the correct directory (should be ~/Desktop/configlabs)  

    ```bash
    pwd 
    helm template oteemocharts/sonarqube > generated.yaml
    ```

5. View contents of the generated file

    ```bash
    cat generated.yaml 
    ```
   > This file should have `Secret`, `ConfigMap`, `Service`, `Deployment`, `StatefulSet`, and `pod` objects.  
   > These kubernetes object files are all in one single `.yaml` file separated by `---` file deliminator  
   
   To view the individual kubernetes objects   
   ```bash
    cat generated.yaml | grep -i kind:
   ```
   Your output should look like this
   ```text
    kind: Secret
    kind: ConfigMap
    kind: ConfigMap
    kind: ConfigMap
    kind: ConfigMap
    kind: ConfigMap
    kind: Service
    kind: Service
    kind: Service
    kind: Deployment
    kind: StatefulSet
    kind: Pod
   ```

6. Template out to multiple files

    Another way to generate would be to a directory, this allows us to have a more manageable way to view all the resources needed for an application

    ```bash
    helm template sonar oteemocharts/sonarqube --output-dir generated
    ```

7. View files created

    ```bash
    ls -R generated
    ```

    This will have all the same contents, just split up over the different files

## Other ways to interact with Helm
https://helm.sh/docs/intro/using_helm/
