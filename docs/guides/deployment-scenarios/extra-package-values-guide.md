# Values for Extra Packages

The Big Bang `values.yaml` file is able to pass through values for extra packages

For example:
```yaml
packages:
  podinfo:
    enabled: true
    values:
      resources:
        requests:
          cpu: 100m
          memory: 100Mi
        limits:
          cpu: 200m
          memory: 200Mi
```

This will pass the `resources` config to the `podinfo` package.  

You can also use some Big Bang used conditionals into your package.

For instance:

If you have Istio enabled:
```yaml
istio:
  enabled: true
```
Then you can also enable the wrapper functionality and enable istio for the wrapper.
```yaml
packages:
  podinfo:
  wrapper:
    enabled: true
    values:
      istio:
        enabled: true
```
Or if you would like to use conditionals to make your `extra-package` deployment adapt to your Big Bang deployment:

```yaml
packages:
  podinfo:
    values:
      istio:
        enabled: "{{.Values.istio.enabled}}"
```
This way, Istio will only be configured in the wrapper for your `extra-package` if Istio is enabled for BigBang.


Using this functionality will streamline your package deployment for anyone looking to use your package in Big Bang.
