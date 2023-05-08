## Authorization Policy

Authorization is answering the access control portion of the question. Is an (authenticated) principal allowed to perform an action on an object? Can user A send a GET request to path /hello to Service A? Note that principal could be authenticated, however, it might not be allowed to perform an action.

Your company ID card might be valid and authentic, however, I won't be able to use it to enter offices of a different company. If we continue with the customs officer metaphor from before we could say authorization is similar to a visa stamp in your passport.

This brings us to the next point, having authentication without authorization (and vice-versa) doesn't do us much. For proper access control we need both. Let me give you an example: if we only authenticate the principals and we don't authorize them, they can do whatever they want and perform any actions on any objects. Conversely, if we authorize a request, but we don't authenticate it, we can pretend to be someone else and perform any actions on any objects again.

Armed with an authenticated principal, we can now decide to restrict access based on that. To do that, we use an `AuthorizationPolicy`. The `AuthorizationPolicy` resource is where we can make use of the principal from the `PeerAuthentication` policies and from the `RequestAuthentication` policy. If we are trying to write policies based on the peer or service identities, we can use the principals field, and if we’re making decisions based on the users we’d use request principals.

This example applies the authorization policy to all workloads matching the `app=prod` label. The second part of the resource is where we’re defining the rules and saying that we are allowing calls from a source that has any `requestPrincipal` set. Note that we aren’t checking for any specific principal here, but just that the principal is set. With this authorization policy and the `RequestAuthentication` policy we are guaranteeing that only authenticated requests will reach the prod workloads.

```{.yaml .language-yaml}
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: require-jwt
  namespace: default
spec:
  selector:
    matchLabels:
      app: prod
  rules:
  - from:
    - source:
        requestPrincipals: ["*"]
```

The previous example was a simple one, but there are multiple ways we can write rules in the authorization policies. We’ve seen the `from` field in the previous example.  With `from` you can define a list of source identities, namespaces, and principals that are allowed to call the services we’ve applied the policy to.

This example will allow calls from services that use the workload service account, are coming from the prod namespace and have the request principal set to `tetrate.io/nauticalmike`.

```{.yaml .language-yaml}
rules:
- from:
  - source:
      principals: ["cluster.local/ns/default/sa/workload"]
  - source:
      namespaces: ["prod"]
  - source:
      requestPrincipals: ["tetrate.io/nauticalmike"]
```

All these sources, principals, request principals, namespaces, IP blocks have negative matches as well; so we could write `notPrincipals` or `notNamespaces` to include a list of negative matches. For example, if we want to apply the rules to all the namespaces except the `prod` namespace, then we could write `notNamespaces: ["prod"]`.

The second field is the `to` field. This is where we can specify what paths, methods, ports, or hosts can be used when making the calls to the service. This example shows that we can call `DELETE` on the `/logs` path, call `GET` on the `/data` path, and allow ports `3000` or `5000` for requests from `request.host`:

```{.yaml .language-yaml}
rules:
- from:
  - ...
  to:
  - operation:
      methods: ["DELETE"]
      paths: ["/logs*"]
  - operation:
      methods: ["GET"]
      paths: ["/data"]
  - operation:
      hosts: ["request.host"]
      ports: ["3000", "5000"]
```

Just like with the `from` field, we can also write negative matches. For example, `notMethods`, `notPath`, and `notHosts`.

Finally, the `when` field allows us to specify different conditions based on the request's attributes (e.g. headers, source IP, remote IP, namespaces, principals, destination ports, connection SNI).

This example shows that we can only make the calls `from` and `to` when the request has a valid JWT token that was issued by `accounts.google.com`, when the `my-header` contains `some-value` and the request is coming from the `foo` namespace:

```{.yaml .language-yaml}
rules:
- from:
  to:
  when:
    - key: request.auth.claims[iss]
      values: ["https://accounts.google.com"]
    - key: request.headers[my-header]
      values: ["some-value"]
    - key: source.namespace
      value: ["foo"]
    ...
```

Once we've written the rules, we can configure the action. We can either `ALLOW` or `DENY` the requests matching those rules. Additional supported actions are `CUSTOM` and `AUDIT`.

The `CUSTOM` action is when we specify our own custom extension to handle the request. The custom extension needs to be configured in the `MeshConfig`. An example of using this would be if you wanted to integrate a custom external authorization system in order to delegate the auth decisions. Note that the `CUSTOM` action is experimental, so it might break or change in the future Istio versions.

The `AUDIT` action can be used to audit a request that matches the rules. If the request matches the rules, the `AUDIT` action would trigger logging that request. This action does not affect where the request is allowed or denied. Only `DENY`, `ALLOW` and `CUSTOM` actions can do that. A sample scenario for when you could use the `AUDIT` action is when you’re migrating your workloads from `PERMISSIVE` to `STRICT` mTLS mode.

```{.yaml .language-yaml}
spec:
  action: DENY
  rules:
  - from:
    to:
    when:
    ...
```

In summary, services get their identity through x509 certificates (which in Kubernetes is from the service accounts). The `PeerAuthentication` resource is used to control the communication between the services. This is where you can set the mutual TLS mode to `PERMISSIVE` or `STRICT`.

When services are authenticated, certain metadata about the service, like the principal name, is stored and can be used later to enforce access control. To authenticate users with JWT tokens, we can use the `RequestAuthentication` resource. Once users are authenticated the information from the JWT token can be used to perform access control.

Finally, once we have the authenticated principal (be it the service or user), we can  use an `AuthorizationPolicy` to specify which services can call the workloads and set conditions for methods and paths.

## Next

We turn our attention next to the security lab.