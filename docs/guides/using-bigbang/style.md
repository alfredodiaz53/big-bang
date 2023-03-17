# General Conventions Style Guide
This style guide outlines the general conventions to follow for package names, structure standardization, version numbers, and YAML formatting.

## Package Names
When creating package names, follow these guidelines:

- Use only lowercase letters and numbers.
- Use dashes (-) to separate words.
- Do not use uppercase letters or underscores.
- Do not use dots in package names.
- Ensure that package names are consistent between the git repository, namespace, resource prefixes, and labels.
- Use Helm's kebab-case function to translate package names from YAML to Kubernetes resource names. This replaces capital letters with a hyphen (-) and the lowercase version of the letter.
##### Notable Exceptions
> If a package name is two words and the additional words are less than four characters, consider it as part of the single name. Examples include "fluentbit" (technically "Fluent Bit") and "argocd" (technically "Argo CD").

## Structure Standardization
For each package, ensure that the following items have the same name:

- Folder: chart/templates/<package>
- Top-level key: chart/templates/values.yaml
- Namespace: chart/templates/<package>/namespace.yaml, unless targeting another package's namespace.
- Repo name: https://repo1.dso.mil/bigbang/packages/<package>/

## Version Numbers
This section is a work in progress, and we suggest updating it when finalized.

##

Consistency is key when it comes to formatting choices. Ensure that your changes to Big Bang follow these formatting guidelines consistently throughout.

Remember that these conventions are meant to serve as a starting point, and it's always important to consider the specific needs and constraints of your contribution when making decisions about package names, structure, versioning, and formatting.
