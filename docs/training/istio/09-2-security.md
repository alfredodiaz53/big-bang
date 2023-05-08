## Peer Authentication

`PeerAuthentication` resource controls the communication between the workloads. Using PeerAuthentication we can configure the mutual TLS (mTLS) mode that's used when workloads communicate. The default mode is set to permissive, so service that do mtls can use mtls and if they only do plaintext everything will still work.

You can control the mutual TLS mode at the mesh level, in specific namespaces, for specific workloads, or for specific ports. For example, you can set up STRICT mTLS for some workloads, but then disable mTLS for communication on specific ports.

This example sets the strict mTLS mode for all workloads in the foo namespace:
```{.yaml .language-yaml}
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: foo
spec:
  mtls:
    mode: STRICT
```

This is similar one, but here we’re setting strict mode only to workloads with the specified label set using the selector and matchLabels field:
```{.yaml .language-yaml}
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: foo
spec:
  selector:
    matchLabels:
      app: prod
  mtls:
    mode: STRICT
```

Finally , port level -- where we set the STRICT mode for all workloads, and disable MTLS for port 5000:
```{.yaml .language-yaml}
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: foo
spec:
  mtls:
    mode: STRICT
  portLevelMtls:
    5000:
      mode: DISABLE
```

## Request Authentication

We’ve talked about services and how they communicate but we haven’t mentioned anything about users, so how do we authenticate users in Istio? The answer relies on the `RequestAuthentication` resource.

The `RequestAuthentication` is used for end user authentication and it verifies the credentials attached to the request. The request-level authentication is done with [JSON Web Token](https://jwt.io/introduction) (JWT) validation. So just like we used SPIFFE identity to authenticate the services, we can use JWT tokens to authenticate users.

This `RequestAuthentication` resource applies to all workloads in the default namespace that have the app: httpbin label set:

```{.yaml .language-yaml}
apiVersion: security.istio.io/v1beta1
kind: RequestAuthentication
metadata:
  name: httpbin
  namespace: default
spec:
  selector:
    matchLabels:
      app: httpbin
  jwtRules:
  - issuer: "issuer-foo"
    jwksUri: "someuri"
```

Any request made to these workloads will need a JWT token. The `RequestAuthentication` resource configures how the token and its signature is authenticated using the provided key set in the jwksUri field.

If the request to the selected workload does not contain a valid JWT token, the token doesn't conform to the `RequestAuthentication` rules, then the request will be rejected. Similarly, if we don't provide a JWT token at all, the request will be rejected.

Let’s assume we have authenticated the request, once we have that then we can talk about the second part of the original access control question, "performing an action on an object". This is what authorization is about.

Just like the peer authentication, the request authentication can also be scoped at the mesh, namespace, or workload level.

Also, you can configure request authentication at the Ingress level. You can do that by specifying the `istio: ingressgateway` label. If you authenticate at the Ingress, but you want to perform additional JWT token logic (e.g. authorization policies inside your mesh), you can set the `forwardOriginalToken` field to true.  That will pass the original token to upstream services.

Istio takes the `RequestAuthorization` configuration, translates it into the Envoy config, and verifies pieces of the JWT token.

## Next

We turn our attention next to the `AuthorizationPolicy` resource.