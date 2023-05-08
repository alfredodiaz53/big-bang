---
revision_date: ""
tags:
  - bigbang
---

<img src="../images/Big_Bang_Color_Logo.png" width="30%" alt="CNCF Landscape"/>


## What does Big Bang provide?
Big Bang is a Helm chart you can use to build a DevSecOps platform from DoD hardened and approved containers that are deployed to your Kubernetes cluster. Using Big Bang will help you build a custom software factory for your specific mission needs and develop and deploy your mission applications faster. Using Big Bang helps you ensure that your development environment follows the DoD DevSecOps reference design and will be more likely to receive a Continuous ATO.

Big Bang is:

* An umbrella Helm chart that leverages Iron Bank container images to provide a DevSecOps Platform where you can build and host apps.
* Installed on a Kubernetes Cluster that is hosted outside of Platform One.
* Installed and managed using GitOps and Infrastructure as Code. Big Bang Core is installed using Flux(V2). Addons can be installed using Flux or ArgoCD.
* Big Bang Core is Open Source Software (but you can also deploy COTS applications to your cluster through Big Bang).


You can find more information about Big Bang at https://p1.dso.mil/products/big-bang.

## Why use Big Bang
* Secure, stable, and efficient implementation of Kubernetes and DevSecOps. 
* Compliant with the DoD DevSecOps Reference Arch Design
* Faster deployments because infrastructure is defined as code.
* Decreases your security burden by using IronBank container images.
* Reduces maintenance burden by receiving app updates from P1's Big Bang Team.
* "SSO for free." Instead of building SSO into apps, developers can label their pods "protect=keycloak" to automatically integrate SSO with their application.
* It allows groups to collaborate and reuse secure solutions. 


![CNCF Landscape](images/cncf-landscape.png)


## BigBang Deployment

![Big Bang Visualization](images/big-bang-viz.png)

* You deploy Big Bang on your own and contribute back code/documentation. See https://repo1.dso.mil/platform-one/big-bang/customers/template
* Big Bang is designed to be deployed to an existing cluster in your environment.  
* Platform One can work with a vendor or partner to bundle Infrastructure as code and automation to form a Kubernetes Cluster. 


## Big Bang vs. Party Bus
A major difference between Big Bang and Party Bus is that with Party Bus you're using PartyBus CICD pipelines and processes. This means that apps can get a CTF (Certificate to Field) and leverage Party Bus's cATO, which inherit Platform One's ATOs of the underlying infrastructure, which P1's AO (Authorizing Official) has approved.

Installing Big Bang does not mean that you automagically get a cATO or ATO. Consumers of Big Bang need to work with their AOs to get an ATO/cATO. Big Bang Customers are able to get support from Platform One's security team to help with this.

![ATO Layers](images/big-bang-ato-layers.png)
