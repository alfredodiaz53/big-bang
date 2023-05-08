---
revision_date: ""
tags:
  - bigbang
---

## Prometheus
Prometheus is a time series database, which is a database optimized for storing metrics. Instead of being a push based database where it waits for an entity to push data into it. Prometheus is a pull based database, where Prometheus collects the data that it stores in itself. It collects data by "scraping" Metric Endpoints. (It basically periodically curls web pages that host prometheus metrics.)

## Prometheus Operator Components

* **Prometheus Operator Pod**: 
    * reads the desired state of Custom Resources (CRs) and make them a reality.
* **Prometheus CR** 
    * --spawns--> Prometheus StatefulSet
* **AlertManager CR** 
    * --spawns--> AlertManager Statefulset
* **ServiceMonitors and PrometheusRules** 
    * store snippets of configuration for Prometheus and AlertManager. The Prometheus Operator Pod configures Prometheus & AlertManager based on the contents of these CRs (lab)
* **Prometheus** 
    * A database optimized for metrics. It's config is read in from a secret, Prom Op pod dynamically edits the secret based on contents of ServiceMonitors.
* **AlertManager**
    * can send alerts based on metric thresholds
* **Grafana** 
    * shows dashboards and graphs of prometheus metrics
 

* In addition to Prometheus, Grafana, AlertManager, Prometheus Operator and it's Custom Resources the following are also part of the Prometheus Operator Stack.
* The Grafana deployment has a sidecar container, that makes it so ConfigMaps that follow a convention can be used to automatically import Dashboards into Grafana. (lab)
* kube-state-metrics deployment makes some additional Kubernetes metrics available to Prometheus
* Prometheus Node Exporter Daemonset makes node level metrics available to Prometheus


## Example Prometheus CR

The Prometheus Operator Pod spins up Prometheus Server Pods based on the Prometheus Custom Resource:
# (Notice prometheus is a recognised kubernetes object type, it stores the desired state / configuration, showing replica config snippet as example) 

```bash
kubectl get prometheus --all-namespaces
NAMESPACE NAME AGE
monitoring k8s 3d5h
```

```bash
kubectl get prometheus k8s -n=monitoring -o yaml | grep replicas
replicas: 2
```

```bash
kubectl get pod -n=monitoring -l=app=prometheus
NAME              READY  STATUS   RESTARTS  AGE 
prometheus-k8s-0  3/3    Running  1         3d5h 
prometheus-k8s-1  3/3    Running  1         3d5h
```

## PromQL

**What is PromQL:**
Prometheus has it's own query language called PromQL.

**Basic Examples of what PromQL looks like:**
kube_pod_container_status_last_terminated_reason 
kube_pod_container_status_last_terminated_reason{reason="Completed"} 
(you can filter the metrics down to a subset by using tags)

**What is PromQL used for:**
* Creating Metric Based Alerts in AlertManager
* Creating Graphs in Grafana based on Prometheus Metrics
* You'd only need to know it if you were creating or customizing a Grafana

Dashboard or setting up Alerts, the best way to learn it is to explore PromQL entries that are used to generate dashboards.


## GitOps

The Prometheus Operator Stack is GitOps friendly:

* ServiceMonitors can be used to configure Prometheus's Metric Collection.
* PrometheusRules can be used to configure Automated Alerts
* ConfigMaps that follow a convention can be used to automatically import Dashboards into Grafana.

All of these tasks can be done by creating a YAML and doing a kubectl apply, or uploading said YAML to a git repo and letting GitOps operator / software bot kubectl apply on your behalf.
