---
revision_date: ""
tags:
  - bigbang
---
# Security Tools

## Keycloak

* What is a keycloak ?
    * single sign-on solution
    * open source
    * Compliant with standard protocols like OIDC and SAML so it can integrate with many
        * Identity providers
* P1's implementation allows SSO with CAC cards (a plugin is baked in that can federate against the x509 certs associated with CAC cards)


### AuthService (Authentication Proxy)

Envoy, Istio's Proxy engine, has a feature to protect workloads with an Authentication Proxy, where you can force users to Authenticate with an SSO provider before they see the service behind the authentication proxy.

AuthService is a BigBang supported Addon

### AuthService, KeyCloak, and BigBang

* AuthService is a BigBang addon, when enabled it's default configuration will point to P1's SSO Solution [https://login.dso.mil](https://login.dso.mil), which is P1's hosted Keycloak.
* BigBang's Authentication Proxy can interface with any OIDC/SAML id provider, it doesn't have to be KeyCloak.
* If you want AuthService to point to your own instance of Keycloak instead of P1's hosted keycloak, then you can deploy the keycloak BigBang addon* (non-standard addon).

What makes Keycloak a non-standard addon is that usually running all the addons you like in 1 big cluster would be considered supported. In the case of Keycloak it's recommended to deploy it into its own dedicated cluster.


## Anchore

* [Anchore Engine](https://github.com/anchore/anchore-engine) is an open-sourced container security platform.  
* Anchore is service that analyzes docker images and scans for vulnerabilities
* It is an optional add-on to Big Bang
* Features include
    * Container Image analysis
    * Policy Management
    * Continuous monitoring
    * CI/CD Integration
    * Integration with Kubernetes

### Image Analysis

* During image analysis, software library and files are inspecting and stored in the Anchore DB
* Anchore will also watch the image repository for updates to a given container tag

![Anchore Analysis](anchore-analysis.png)


### Policy Management

* Policy management adds another level to container scanning including
    * Package allow/block lists
    * Configuration file contents
    * Image manifest changes
    * Presence of credentials in images
* Each policy can be a Stop or Warn
* When scanning, any stop actions will fail a pipeline


## Open Policy Agent

* **Policy**
    * “Rules that tell us whether we can create a resource or make change an existing resource”
* **Policy Management**
     * “The practice of developing, deploying and using policy objects”
* **Open Policy Agent**
    * Open Policy Agent (OPA) is a general-purpose policy engine with uses ranging from authorization and admission control to data filtering.
* **Goals**
    * “Stop using a different policy language, policy model, and policy API for every product and service you use. Use OPA for a unified toolset and framework for policy across the cloud native stack.”

### Config vs Policy Management

**Config Management**
* Lets you define/store/control configuration for a resource
* Config mgmt is the process itself and solutions include GitOps
* Config management only enforces the end cluster resource state
* Helps with defining and implementing configuration as code (CaC)

**Policy Management**
* Lets you govern the resource changes
* Allows the enforcement over the process - whether a change can be applied or denied
* Policies can admit/deny/audit new or existing cluster resources
* Helps with governance, compliance and auditing of the policies


### OPA Architecture

![OPA Architecture](../images/opa-architecture.png)

## Gatekeeper

Gatekeeper is a wrapper on an OPA implementation that functions as a validating admission controller webhook inside a k8s cluster

* Validation of Policy Controls
* Policies / Constraints
* Audit Functionality
* Data replication

Gatekeeper is a core package in BigBang

![Gatekeeper Architecture](../images/gatekeeper-architecture.png)



## Prisma

* Prisma can be used in two primary ways
    * As build time image scan/analysis/reporting tool
    * As a runtime monitoring tool
        * IDS
        * IPS
* Prisma is a Big Bang package, but licenses are not provided
* Prisma for Kubernetes
    * Deployed as a Daemonset in the cluster
    * Monitors Node Settings like:
        * IP-tables
        * FirewallD
        * Open Ports
        * Container Syscalls on the host

