---
revision_date: ""
tags:
  - bigbang
---

## Layered Architecture
It is essential to define each Cluster Layer as IaC/CaC and ensure automation is in place.

![IaC/CaC Layers](../images/dev-sec-ops/0-layers.png)


### VM Layer
Different Deployment Environments have different types of VM Images:
  * AWS has AMIs: Amazon Machine Images
  * Azure has Azure Managed VM Images
  * VMware has .vmdk Images

Packer is a tool that can create VM Image types that match the deployment environment automatically.
  * Use Packer with an ansible-remote provisioner to run Ansible Playbooks on a remote host during the Image Creation Process.
      * OpenSCAP: public ansible scripts to bring a VM to STIG compliance/C2S hardened.
      * Inspec: Tests & verifies infrastructure configuration.

![VM Layer](../images/dev-sec-ops/1-vm-layer.png)


### Infrastructure Provisioning Layer
Terraform is a tool that automates the process of creating infrastructure. It uses VM Images made in the previous layer to provision VMs.

Terraform can be used to define Networking, Supporting Services, and VMs as Code and automate their provisioning.

It works for AWS, Azure, VMware and others.

![VM Layer](../images/dev-sec-ops/2-infra-layer.png)


### Kubernetes Layer
Kubernetes Distributions are like Linux Distributions. Big Bang Clusters come in flavors:
* "Upstream Kubernetes" (kubeadm/archosaur/dod-tanzu)
* Konvoy (Managed Kubernetes Cluster by D2IQ)
* Rancher Kubernetes Engine
* RedHat's OpenShift Container Platform (BOY*)
* (and more)

![Kubernetes Layer](../images/dev-sec-ops/3-k8s-layer.png)


### Cluster Services Layer
"Core" Non-Negotiable Services that you'd find in every Big Bang Cluster:
  * Flux
  * Istio
  * Open Policy Agent
  * Prometheus operator stack (Prometheus Grafana AlertManager)
  * Logging operator stack (Elastic FluentD Kibana)

![Cluster Services Layer](../images/dev-sec-ops/4-cluster-services-layer.png)


### Applications Layer
Users can add or remove applications in this layer based on the needs of a particular customer. The ArgoCD umbrella app deploys applications defined in a git repository to the cluster.
 
![Applications Layer](../images/dev-sec-ops/5-apps-layer.png)


## GitOps Goals vs. Expectations
GitOps requires tight coupling of IaC and CaC:

* Users can quickly spin up a replacement cluster(<1 hour) if they destroy a pre-existing stateless cluster or dev cluster spun up using GitOps.
* The fast redeployment time depends on prerequisites and configuration, which can't always be automated/easily streamlined.
    * Deploying a similar cluster in the same AWS account can be figured out in one day.
    * Setting up a new cluster in a new AWS account, air-gapped environment, or restricted environment may require 1-3 weeks of preparation due to team handoffs for prerequisites and configuration.
