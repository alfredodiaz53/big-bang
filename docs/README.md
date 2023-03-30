# BigBang Docs

## What is BigBang?

* BigBang is a Helm Chart that is used to deploy a DevSecOps Platform on a Kubernetes Cluster. The DevSecOps Platform is composed of application packages which are bundled as helm charts that leverage IronBank hardened container images.
* The BigBang Helm Chart deploys gitrepository and helmrelease Custom Resources to a Kubernetes Cluster that's running the Flux GitOps Operator, these can be seen using `kubectl get gitrepository,helmrelease -n=bigbang`. Flux then installs the helm charts defined by the Custom Resources into the cluster.
* The BigBang Helm Chart has a values.yaml file that does 2 main things:
  1. Defines which DevSecOps Platform packages/helm charts will be deployed
  1. Defines what input parameters will be passed through to the chosen helm charts.
* You can see what applications are part of the platform by checking the following resources:
  * [packages.md](./packages.md) lists the packages and organizes them in categories.
  * [Release Notes](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/releases) lists the packages and their versions.
  * For a code based source of truth, you can check [BigBang's default values.yaml](../chart/values.yaml), and `[CTRL] + [F]` "repo:", to quickly iterate through the list of applications supported by the BigBang team.


### What BigBang isn't

* BigBang by itself is not intended to be an End to End Secure Kubernetes Cluster Solution, but rather a reusable secure component/piece of a full solution.
* A Secure Kubernetes Cluster Solution, will have multiple components, that can each be swappable and in some cases considered optional depending on use case and risk tolerance:
  Example of some potential components in a full End to End Solution:
  * P1's Cloud Native Access Point to protect Ingress Traffic. (This can be swapped with an equivalent, or considered optional in an internet disconnected setup.)
  * Hardened Host OS
  * Hardened Kubernetes Cluster (BigBang assumes ByoC, Bring your own Cluster) (The BigBang team recommends consumers who are interested in a full solution, partner with Vendors of Kubernetes Distributions to satisfy the prerequisite of a Hardened Kubernetes Cluster.)
  * Hardened Applications running on the Cluster (BigBang helps solve this component)


## Value add gained by using BigBang

* Compliant with the [DoD DevSecOps Reference Architecture Design](https://dodcio.defense.gov/Portals/0/Documents/Library/DoD%20Enterprise%20DevSecOps%20Reference%20Design%20-%20CNCF%20Kubernetes%20w-DD1910_cleared_20211022.pdf)
* Can be used to check some but not all of the boxes needed to achieve a cATO (Continuous Authority to Operate.)
* Uses hardened IronBank Container Images. (left shifted security concern)
* GitOps adds security benefits, and BigBang leverages GitOps, and can be further extended using GitOps.
  Security Benefits of GitOps:
  * Prevents config drift between state of a live cluster and IaC/CaC source of truth: By avoiding giving any humans direct kubectl access, by only allowing humans to deploy via git commits, out of band changes are limited.
  * Git Repo based deployments create an audit trail.
  * Secure Configurations become reusable, which lowers the burden of implementing secure configurations.
* Lowers maintainability overhead involved in keeping the images of the DevSecOps Platform's up to date and maintaining a secure posture over the long term. This is achieved by pairing the GitOps pattern with the Umbrella Helm Chart Pattern.
  Let's walk through an example:
  * Initially a kustomization.yaml file in a git repo will tell the Flux GitOps operator (software deployment bot running in the cluster), to deploy version 1.0.0 of BigBang. BigBang could deploy 10 helm charts. And each helm chart could deploy 10 images. (So BigBang is managing 100 container images in this example.)
  * After a 2 week sprint version 1.1.0 of BigBang is released. A BigBang consumer updates the kustomization.yaml file in their git repo to point to version 1.1.0 of the BigBang Helm Chart. That triggers an update of 10 helm charts to a new version of the helm chart. Each updated helm chart will point to newer versions of the container images managed by the helm chart.
  * So when the end user edits the version of 1 kustomization.yaml file, that triggers a chain reaction that updates 100 container images.
  * These upgrades are pre-tested. The BigBang team "eats our own dogfood". Our CI jobs for developing the BigBang product, run against a BigBang dogfood Cluster, and as part of our release process we upgrade our dogfood cluster, before publishing each release. (Note: We don't test upgrades that skip multiple minor versions.)
  * Auto updates are also possible by setting kustomization.yaml to 1.x.x, because BigBang follows semantic versioning, flux is smart enough to read x as the most recent version number.
* DoD Software Developers get a Developer User Experience of "SSO for free". Instead of developers coding SSO support 10 times for 10 apps. The complexity of SSO support is baked into the platform, and after an Ops team correctly configures the Platform's SSO settings, SSO works for all apps hosted on the platform. The developer's user experience for enabling SSO for their app then becomes as simple as adding the label istio-injection=enabled (which transparently injects mTLS service mesh protection into their application's Kubernetes YAML manifest) and adding the label protect=keycloak to each pod, which leverages an EnvoyFilter CustomResource to auto inject an SSO Authentication Proxy in front of the data path to get to their application.


## How do I deploy BigBang?

**Note:** The Deployment Process and Pre-Requisites will vary depending on the deployment scenario. The [Quick Start Demo Deployment](./guides/deployment-scenarios/quickstart.md) for example, allows some steps to be skipped due to a mixture of automation and generically reusable demo configuration that satisfies pre-requisites.
The following is a general overview of the process, the [deployment guides](./guides/deployment-scenarios) go into more detail.

1. Satisfy Pre-Requisites:
   * Provision a Kubernetes Cluster according to [best practices](./prerequisites/kubernetes-preconfiguration.md#best-practices).
   * Ensure the Cluster has network connectivity to a Git Repo you control.
   * Install Flux GitOps Operator on the Cluster.
   * Configure Flux, the Cluster, and the Git Repo for GitOps Deployments that support deploying encrypted values.
   * Commit to the Git Repo BigBang's values.yaml and encrypted secrets that have been configured to match the desired state of the cluster (including HTTPS Certs and DNS names).  
1. `kubectl apply --filename bigbang.yaml`
   * [bigbang.yaml](https://repo1.dso.mil/platform-one/big-bang/customers/template/-/blob/main/dev/bigbang.yaml) will trigger a chain reaction of GitOps Custom Resources' that will deploy other GitOps CR's that will eventually deploy an instance of a DevSecOps Platform that's declaratively defined in your Git Repo.
   * To be specific, the chain reaction pattern we consider best practice is to have:
     * bigbang.yaml deploys a gitrepository and kustomization Custom Resource
     * Flux reads the declarative configuration stored in the kustomization CR to do a GitOps equivalent of `kustomize build . | kubectl apply  --filename -`, to deploy a helmrelease CR of the BigBang Helm Chart, that references input values.yaml files defined in the Git Repo.
     * Flux reads the declarative configuration stored in the helmrelease CR to do a GitOps equivalent of `helm upgrade --install bigbang /chart  --namespace=bigbang  --filename encrypted_values.yaml --filename values.yaml --create-namespace=true`, the BigBang Helm Chart, then deploys more CR's that flux uses to deploy packages specified in BigBang's values.yaml
  
## New User Orientation

* New users are encouraged to read through the Useful Background Contextual Information present in the [understanding-bigbang folder](./understanding-bigbang)

## Frequently Asked Questions

### **Costs and licensing fees**

> Will a user, government program, or support contract incur any costs, other
than their own labor, for installing and using BigBang?
 
BigBang itself is open-source, and you do not need to pay Platform One
to use it in your environment.

Out baseline includes multiple software components, with a variety 
of open-source and commercial licenses. Details of these components and
their licensing models can be found here: 
[BigBang Licensing Model Overview](https://docs-bigbang.dso.mil/1.54.0/docs/understanding-bigbang/licensing-model/)

In BigBang 2.0, we will be separating our distribution into an open-source
core and commercial add-ons package, for increased clarity.

You are in complete control over which components you install in your
environment, and choose whether or not to use commercial software.
However, certain commercial applications, such as Twistlock, will be
required for a cATO.

> Are users required to set up a "contract" with Platform One in order to
use BigBang?

No. BigBang is open source, and can be used by you and your organization
without payment to Platform One.

Platform One does offer optional hosting and support contracts. If you
have your own cluster but need help installing and operating BigBang,
our BigBang Integration Team will be able to help. And if you don't have
a cluster at all, your environment can be hosted on Party Bus. Finally,
if you want Platform One to deploy an instance of your environment to
make sure changes to our baseline won't break your integration tests,
consider setting up a Digital Twin

<!--
TODO: link to BBI
TODO: link to Party Bus
TODO: link to Digital Twin
-->

> Do we need a government PM to send a formal request to Platform One in order
to get started?

No. Big Bang is Open Source, and you do not need our permission to use it.
However, we always like to hear from our users, both to know how large an 
impact this effort is making, and to make sure we are addressing our users'
most pressing needs.

<!--
TODO: reach out link
-->

### Accreditation and Reciprocation

> What accreditations does BigBang have? What Impact Levels can it run at?
> Does it run on SIPR and JWICS?

BigBang is compliant with the 
[DevSecOps Reference Architecture](https://dodcio.defense.gov/Portals/0/Documents/Library/DoD%20Enterprise%20DevSecOps%20Reference%20Design%20-%20CNCF%20Kubernetes%20w-DD1910_cleared_20211022.pdf),
and is used at all Impact Levels and Classifications. Each IL and classification is 
deployed to a separate environment and separate cluster, which keeps them separated.

Platform One has various ATO, cATO, and SIL ATO packages based on the environment and use 
case. Our team is working to move these into eMASS. Current controls and eMASS information
will be shared with DoD/Government users on requst.

> If I use BigBang, will I automatically inherit your cATO?
 
No, but using BigBang will likely make it easier to gain a cATO from your Authorizing 
Official (AO). The Air Force is currently revamping and standardizing the cATO process, 
as well, which should make reciprocity even easier.

Since Big Bang is a platform that rides on top of a Kubernetes distribution and 
Infrastructure (on-prem, cloud, etc), those areas are not covered specifically by 
Big Bang, but as part of the complete environment need to be secured and considered in an 
ATO package. 

Theoretically, if a Big Bang deployment was configured the same as our deployment, on the s
ame Kubernetes distribution, and on the same Infrastructure configuration, then it would 
check all the boxes necessary for a cATO.

Conversely, misconfiguration a deployment of BigBang, for example by turning off the 
service mesh or runtime security, would "uncheck" the boxes necessary for a cATO.

Because of these factors, any instance of BigBang must be evaluated individually. However,
BigBang and Iron Bank are meant to do as much of the heavy lifting as possible.

> Is Bang Bang considered a hardened DevSecOps Software Factory such that
if you build a container or an application/service using Big Bang and its
business processes and policies that then that container or
application/service is automatically is ready for an CtF or C-ATO
 
No; simply building an application on PartyBus does not automatically grant a CtF.
In the cast of [Party Bus](https://p1.dso.mil/products/party-bus), a managed instance
of BigBang, it is the robust pipelines that must be passed by an application and the 
process, pipeline, and findings approved by Cyber provides a CTF. We are in the process
of generalising these pipelines, so that they can be used by any BigBang customer,
which will make it easier to obtain a CtF or cATO, even when running your own instance
of BigBang.


> Is BigBang secure? What about its plugins?

BigBang performs automated scans of all components, and patches vulnerabilities as
they are found. Hardened images are pulled from [Iron Bank](https://p1.dso.mil/products/iron-bank).

### Deployment

> Can we stand up our own instance of BigBang in AWS GovCloud? 

Yes. BigBang strives to be vendor-agnostic, and will run on Cloud One,
AWS GovCloud, Microsoft Azure, on-prem hardware, and in air-gapped 
environments.

> Do we have to set up a full Kubernetes distribution? Can we just deploy BigBang
> to a VM?

BigBang is, at its core, a Helm chart, which creates templates for Kubernetes
resources. As such, BigBang requires a full K8S environment.

If your organization is unable to support a full K8S environment, you may wish to
consider [Party Bus](https://p1.dso.mil/products/party-bus), which is BigBang's
managed Platform as a Service (PaaS) solution.

### Change Control

> How do you manage change control on BB? How can we be notified of changed?

BigBang has a two-week release cadence. You can view our
[release schedule](https://docs-bigbang.dso.mil/1.54.0/#Navigating-our-documentation),
our [project milestones](https://repo1.dso.mil/groups/big-bang/-/milestones),
and our [release notes](https://docs-bigbang.dso.mil/1.54.0/release-notes/)
for more information.


### Documentation and Briefings

> Can you provide the latest documentation and briefings?

The most up-to-date information on BigBang can be found here:
[BigBang Docs](https://docs-bigbang.dso.mil/latest/docs). These docs
are fully searchable.
