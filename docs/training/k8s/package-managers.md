---
revision_date: ""
tags:
  - bigbang
---

## What is a package manager?


## Helm




* Helm is a configuration management tool for Kubernetes
* It uses a set of templates to allow customization of application configuration
* It is a CNCF project with a large community built around it
* Key Concepts:
    * Helm chart is a bundle of information necessary to create an instance of a Kubernetes application.
    * The chart contains configuration information that can be merged into a packaged chart to create a releasable object.
    * A release is a running instance of a chart, combined with a specific config.

### Helm Charts
* Application Packages are called Helm Charts
* A chart is a way to define an application
* File Structure:
    * **Chart.yaml**: Author, version, description, image location
    * **values.yaml**: default configuration values for chart 
    * **templates**: Templatized Kubernetes resources that will be paramterized at installation time.
* Helm CLI is available from GitHub or Homebrew

### Helm Chart Structure
```
MyChart/
|── Chart.yaml                     #Required
|── LICENSE
|── values.yaml                    #Required
|── values.schema.json 
|── charts/                        #Required
    └── dependent charts 
|── crds/ 
    └── needed crds 
└── templates/                     #Required
    |── deployment.yaml 
    |── ingress.yaml
    |── service.yaml
    |── NOTES.txt
    └── tests/
        └── test-connection.yaml
```

### Example Helm Chart Files

**Example values.yaml**
```yaml
# The istio profile to use
profile: default

# The hub to use for the image (note: the image is built as
hub: registryl.dsop.io/ironbank/opensource/istio

# The tag to use for the image
tag: 1.7.3
# The hostname to use for the default gateway
hostname: bigbang.dev

imagePullSecrets:
  []
# - private-registry

tls:
  credentialName: wildcard-cert 
  mode: SIMPLE
```


**Example tempalte file**
```yaml
apiVersion: install.istio.io/vlalpha1
kind: IstioOperator
metadata:
  name: istiocontrolplane
  namespace: {{ .Release. Namespace }}
spec:
  profile: {{ .Values.profile }}
  hub: {{ .Values.hub }}
  tag: {{ .Values.tag }}

  components:
    ingressGateways:
      - name: istio-ingressgateway
      namespace: {{ .Release.Namespace }}
      enabled: true
      k85:
        hpaSpec:
          minReplicas: {{ .Values.ingressGateway.minReplicas }}
          maxReplicas: {{ .Values.ingressGateway.maxReplicas }}
          metrics:
            - type: Resource
              resource:
                name: cpu
                targetAverageUtilization: 60
          scaleTargetRef:
            apiVersion: apps/v1
            kind: Development
```

### How Big Bang uses Helm
* Helm can manage a charts lifecycle
* Flux can manage the chart lifecycle
* All Core Big Bang components are installed as Helm Charts


## Kustomize
Kustomize is template free configuration customization for Kubernetes that allows you to reuse manifests across all of your environments (dev, stage, prod) and then overlay unique specifications for each.

* Kustomize has a CLI for managing kubernetes style objects in a declarative way
* It is built into kubectl natively
* You will declaratively define customizations to any file where needed
    * This is done through overlay files that customize the base yaml configurations
    * kustomize build .

### Kustomize File Structure
```
hello-world/ 
|── base
| ├── deployment.yaml
| └── kustomization.yaml
└── overlays
    |── production
    | ├── replica_count.yaml
    | └── kustomization.yaml 
    └── staging
      ├── replica_count.yaml 
      └── kustomization.yaml
```
### Kustomize File Rendering
Assuming the structure above, let's see how kustomize combines base files and overlays to arrive at a materialized file.  Assume the files below:

**`hello-world/base/deployment.yaml`**
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

**`hello-world/base/kustomization.yaml`**
```yaml
resources:
  - deployment.yaml
```

**`hello-world/overlays/staging/replica_cound.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metatdata:
  name: hello-world
spec:
  replicas: 3
```

**`hello-world/base/kustomization.yaml`**
```yaml
bases:
  - dep../../base
patches:
  - replica_count.yaml
```

The resultant output of running the following command, notice that the `replicas` spec has been updated to `3`.

```bash
kustomize build hello-world/overlays/staging/
```

Will be the below:
```yaml
apiVersion: apps/v1 
kind: Deployment 
metadata:
  name: hello-world
spec:
  replicas: 3
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


### Additional Kustomize Features
* Name prefix
    * Add a prefix to all resource names
* Common Labels
    * Adds labels to all resources
* Common Annotations
    * Adds annotations to all resources
* ConfigMap Generator
    * Take a file and turns the contents into a configmap
* SOPS Secret Generator
    * (Big Bang Enabled alpha plugin) Take a file and turns the contents into a Secret