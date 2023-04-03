### Deployment of Renovate

Follow the [Extra Package Deployment Guide](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/guides/deployment-scenarios/extra-package-deployment.md)

#### Templated Wrapper Values
``` yaml
packages:
  renovate:
    enabled: true
    git:
      repo: https://repo1.dso.mil/big-bang/product/packages/renovate.git
      tag: 32.38.0-bb.1
    values:
      networkPolicies:
        enabled: "{{ $.Values.networkPolicies.enabled }}"
      istio:
        enabled: "{{ $.Values.istio.enabled }}"
      cronjob:
        schedule: '0 1 * * *'
      renovate:
        config: '{
            "platform": "gitlab",
            "endpoint": "https://gitlab.example.com/api/v4",
            "token": "your-gitlab-renovate-user-token",
            "autodiscover": "false",
            "dryRun": true,
            "printConfig": true,
            "repositories": ["username/repo", "orgname/repo"]
        }'
```

#### Config
The configuration sets up a self-hosted instance of Renovate that connects with a platform. In the example we connect to GitLab using the GitLab API v4 at a specified URL.

##### Auth
Recommended to use a repository auth token.

##### Repositories
The repositories key in this self-hosted renovate configuration specifies which repositories should be included in the update checks performed by renovate Accepts an array of strings or objects.

See [Self Hosted Configuration](https://docs.renovatebot.com/self-hosted-configuration/#self-hosted-configuration-options) for more details

#### Cron Job
See [Scheduling Renovate Guide](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/guides/renovate/scheduling.md)

#### Individual Package Configuration
The configuration file for Renovate is called `renovate.json` and is located in each project's root directory. See [Package Configuration](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/guides/renovate/package-configuration.md) 