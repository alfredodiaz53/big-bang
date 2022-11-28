# Dev Workflow with OCI

If you want to test deployment of a package off of your dev branch you have two options. This doc covers the OCI workflow, the Git workflow requires nothing more than the values specified in [example git values](../assets/configs/example/git-repo-values.yaml).

## Package Chart for OCI

After making your changes to a chart you will need to package it with `helm package chart`. You should see output similar to the below:

```
Successfully packaged chart and saved it to: /Users/me/bigbang/anchore/anchore-1.19.7-bb.4.tgz
```

## Pushing OCI "somewhere"

In order to use this OCI artifact you will need to ...