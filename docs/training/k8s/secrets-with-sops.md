---
revision_date: ""
tags:
  - bigbang
---

## Secrets in Git

Problem with Secrets in Git:

* A Private Git Repo with cleartext secrets gets cloned to 100 laptops, 1 leak is bad, so you'd encrypt as a counter measure.
* GitOps needs a human and automation friendly way of decrypting the secrets. This causes a new problem of where to store, how to distribute, and how to give access to the decryption key(s), and it's not just as simple as giving both CICD bots and humans access, there's also the angle of access to dev secrets, but not staging or prod vs access to dev, staging, and prod secrets.
* You have no way of knowing if the decryption key was leaked. Usually you could consider encryption key rotation a compensating control, but that becomes a non option due to the distributed nature of git, which makes it so you can't erase history with absolute certainty, someone could use a leaked key with an old copy of the repo that was encrypted with that key.


## Encryption as a Service

**What is Encryption as a Service (EaaS)?**
* A paradigm shift:
    * Instead of clients decrypting data directly using a decryption key
    * Clients decrypt data indirectly using their identity

**How it works:**
Encryption services store and use decryption keys on behalf of clients, so clients never touch keys. Clients send encrypted data to the service and get decrypted data back, and vice versa. (Encryption/Decryption rights get attached to the clients identity.)

Often also called Key Management Services (KMS)

### Examples

Examples of Encryption as a Service:
* HashiCorp Vault's Transit Secrets Engine
* AWS/GCP KMS (Key Management System)
* Azure Key Vault

## SOPS
SOPS (Secrets Operations) is a CLI tool from Mozilla that abstracts away the complexity of interacting with KMS/EaaS.

[https://github.com/mozilla/sops](https://github.com/mozilla/sops)

## SOPS + KMS/EaaS

Secrets are Encrypted at Rest both in the Git Repo AND on human laptops.
* Editing a secret involves temporarily decrypting it in RAM, then encrypting it before saving to disk.
* SOPS workflows tend to involve decrypting in RAM, cleartext secrets only being leveraged in RAM or transfered over encrypted network connections.
* Encryption/Decryption Service makes decryption audit logs possible. Decryption Audit logs can tell you what identity decrypted data and when.
* Identity/Rights based decryption makes RBAC access to decryption trivial. You can use a dev KMS key to decrypt secrets in a dev environment, and give users in the devs RBAC group rights to only that key. You can use a different KMS key for prod, and give Ops RBAC group rights to use multiple KMS keys.
* You can revoke an identity's rights to decrypt a secret.
* This functionality wasn't possible before EaaS/KMS, and SOPS makes it easy.


## BigBang's SOPS Workflow

* Human's work from a machine with IAM rights to a KMS key.
* The machine has SOPS installed, which detects the IAM rights on the machine and abstracts away some of the complexity of interfacing with KMS.
* Human uses SOPS to create an encrypted Secret.
* BigBang uses a custom build of ArgoCD which has SOPS plugins enabled, and Fluxv2, BigBang's custom ArgoCD pod is running on a machine with IAM rights to access KMS, so ArgoCD/Flux are able to decrypt secrets then immediately apply them to the cluster.