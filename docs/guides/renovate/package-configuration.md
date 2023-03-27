# Renovate Configuration for Helm Chart Repository

Renovate is an automated dependency update tool that can be configured to keep dependencies up-to-date in a chart repository. The configuration file for Renovate is called `renovate.json` and is located in each project's root directory. 

Big Bang uses [WhiteSource Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) to identify out-of-date dependencies within supported packages.  When dependency update is needed, Renovate will automatically create a merge request and issue in GitLab to track the work.

## Standards
The following are suggested package requirements based on established policies to resolve dependency updates:

### Images
- All docker images in [Iron Bank](https://registry1.dso.mil) shall be checked for updates.
- All production [GitLab repo](https://repo1.dso.mil) docker images shall be checked for updates.
- All image tags shall be automatically updated if an update is required.
- All image SHAs shall be automatically updated if an update is required.
- Merge requests shall NOT be automatically merged
- Merge requests shall be marked as Draft
- Dashboard issues shall contain the name of the package

### Helm Charts
- Dashboard issues shall have text requesting the upstream Helm chart be updated with the new image.

> Renovate cannot currently handle the use case Big Bang has for syncing the upstream Helm Chart.  We do not want to always get the latest upstream Helm, since it may introduce features not available in the version of the package we are deploying.  In addition, we do want to update the upstream Helm chart to make sure we get the latest fixes and features related to the package. This requires the package owners to find the last Helm Chart release that contains the version of the package residing in Iron Bank.


## Package Configuration

The following options are commonly used to configure the options of Renovate:

### Dashboard options
##### dependencyDashboard
When the Dependency Dashboard is enabled, Renovate will create a new issue in the repository. This issue has a "dashboard" where you can get an overview of the status of all updates. It can accept a boolean value.

##### dependencyDashboardHeader
This key sets a header for the dependency dashboard which lists tasks to be completed by the user. The header will appear at the top of the dependency dashboard. In the given example, the header contains a checklist for updating helm chart versions and synker files. In gitlab this is the issue description. It can accept a string.

##### dependencyDashboardTitle
This key is used to set the title for the dependency dashboard. In the example, it is set as "Renovate: Upgrade Gitlab Dependencies". It can accept a string.

> See [Renovate Configuration](https://docs.renovatebot.com/configuration-options/#dependencydashboard) for more info.

### Package Rules

##### packageRules
This key provides an array of rules that define how packages are matched and grouped. In the example, any matching package with the datasource `docker` will be grouped under the name `Ironbank`. It can accept an array of objects see [Renovate Package Rules Docs](https://docs.renovatebot.com/configuration-options/#packagerules) for more info.

### RegEx
##### regexManagers
This key specifies regex-based rules for updating dependencies. Several `regexManagers` are defined in the example, each with a specific `fileMatch` path and `matchStrings` regex. It can accept an array of objects.

##### File Match

The `fileMatch` array is a list of files that you want to parse.  It uses a regular expression match on the files starting in the repository base directory.  For example `["^chart/values\\.yaml$"]` will match the `chart/values.yaml` file.

##### Match Strings

`matchString` is used to identify the current version, data source type, dependency name or current digest in a file.   You must use special capture groups in regex to identify these items, or create a template for Renovate to understand.  The following are required to be captured:

- `<currentValue>`: This is the current version or tag of the dependency (e.g. v1.2.3)
- `<datasource>`: This is the type of the dependency.  For Iron Bank, Big Bang uses `docker`.
- `<depName>`: This is the name of the dependency and is uses as the repository for the dependency when looking it up in the registry

You can optionally capture `<currentDigest>` as the SHA256 digest for an image if you want renovate to replace this value.

To capture a group, you simply use [regex named groups](https://www.regular-expressions.info/refext.html).  If you cannot capture the group in regex, you can use a `template` to hard code the value.  Here is an example with both capturing and a template:

See [Renovate Configuration](https://docs.renovatebot.com/configuration-options/#regexmanagers) for more details.




### Other options

##### baseBranches
This key is used to specify the base branches for Renovate to compare against. It can accept an array of strings. In the example yaml, Renovate will compare against the `main` branch.

##### configWarningReuseIssue
This key specifies whether to reuse an existing pull request for updates, and whether to warn if an existing pull request cannot be re-used. It can accept a boolean value.

##### draftPR
This key specifies whether the generated pull requests should be marked as drafts. It can accept a boolean value.

##### enabledManagers
This key specifies which dependency managers to enable. In the example, Renovate will use `helm-values` and `regex`.  It can accept an array of strings.

##### ignorePaths
This key lists the file paths for Renovate to ignore when checking dependencies. In the example, Renovate will ignore the files in the `chart/charts/`, `chart/examples/`, and `chart/scripts/` directories. It can accept an array of strings.

##### labels
This key assigns labels to the created pull requests. In the example, the `gitlab` and `renovate` labels are applied. It can accept an array of strings.

##### commitMessagePrefix
This key sets a prefix that will be added to commit messages. In the example, the prefix is set as `SKIP UPDATE CHECK`. It can accept a string.

##### separateMajorMinor
This key specifies whether to separate major/minor updates into separate pull requests. It can accept a boolean value.

##### ignoreDeps 
The configuration field allows you to define a list of dependency names to be ignored by Renovate. Currently it supports only "exact match" dependency names and not any patterns. It can accept an array of strings.

### Example Package Configuration

> The following is based on the Gitlab package's renovate.json.

```json
{
    "baseBranches": ["main"],
    "configWarningReuseIssue": false,
    "dependencyDashboard": true,
    "dependencyDashboardHeader": "- [ ] Sync upstream helm chart. \n - [ ] Update synker file.", 
    "dependencyDashboardTitle": "Renovate: Upgrade Gitlab Dependencies",
    "draftPR": true,
    "enabledManagers": ["helm-values", "regex"],
    "ignorePaths": ["chart/charts/**", "chart/examples/**", "chart/scripts/**"],
    "labels": ["gitlab","renovate"],
    "commitMessagePrefix": "SKIP UPDATE CHECK",
    "packageRules": [
        {
            "matchDatasources": ["docker"],
            "groupName": "Ironbank"
        }
    ],
    "regexManagers": [
        {
            "fileMatch": ["^chart/Chart\\.yaml$"],
            "matchStrings": [
                "appVersion:[^\\S\\r\\n]+(?<currentValue>.+)"
            ],
            "depNameTemplate": "registry1.dso.mil/ironbank/gitlab/gitlab/gitlab-webservice",
            "datasourceTemplate": "docker"
        },
        {
            "fileMatch": ["^chart/Chart\\.yaml$"],
            "matchStrings": [
                "image:[^\\S\\r\\n]+(?<depName>.+):(?<currentValue>.+)"
            ],
            "datasourceTemplate": "docker"
        },
        {
            "fileMatch": ["^chart/values\\.yaml$"],
            "matchStrings": [
                "image:[^\\S\\r\\n]+(?<depName>.+)\\s+tag:[^\\S\\r\\n]+(?<currentValue>[\\d\\.]+)"
            ],
            "datasourceTemplate": "docker"
        }
    ],
    "separateMajorMinor": false
}
```

In conclusion, the `renovate.json` file allows us to configure the Renovate bot to keep our Helm chart repository up-to-date with the latest dependencies, by using various settings to suit our needs.