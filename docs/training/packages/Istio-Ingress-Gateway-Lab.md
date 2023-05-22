# Expose a mock mission app using istio ingress gateway Lab

## Intro
In this lab an nginx pod will repesent a mock mission app that you'll need to expose via the istio ingress gateway.

## Experience Gained
Understanding how virtual services work and route traffic to backend service/pod

1. Create a new directory for istio

    ```bash
    [admin@Laptop:~]
    mkdir -p ~/Desktop/residency/labs/istio-nginx-lab
    cd ~/Desktop/residency/labs/istio-nginx-lab
    ```

2. Create directories for `manifests`, `manifests/app`, `manifests/istio`

    ```bash
    [admin@Laptop:~/Desktop/residency/labs/istio-lab]
    mkdir -p manifests/app
    mkdir -p manifests/istio
    ```

3. Create a nginx-configmap.yaml file inside `manifests/app`

    ```bash
    [admin@Laptop:~/Desktop/residency/labs/istio-nginx-lab]
    vim manifests/app/nginx-configmap.yaml

    # Copy the content below into manifests/app/nginx-configmap.yaml


    apiVersion: v1
    data:
      nginx.conf: |
        user nginx;
        worker_processes auto;
        error_log /var/log/nginx/error.log;
        #pid /run/nginx.pid;
        pid /tmp/nginx.pid;
        # Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
        include /usr/share/nginx/modules/*.conf;
        events {
            worker_connections 1024;
        }
        http {
            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                              '$status $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for"';
            access_log  /var/log/nginx/access.log  main;
            sendfile            on;
            tcp_nopush          on;
            tcp_nodelay         on;
            keepalive_timeout   65;
            types_hash_max_size 2048;
            include             /etc/nginx/mime.types;
            default_type        application/octet-stream;
            include /etc/nginx/conf.d/*.conf;
            server {
                listen       7000 default_server;
                listen       [::]:7000 default_server;
                server_name  _;
                root         /usr/share/nginx/html;
                # Load configuration files for the default server block.
                include /etc/nginx/default.d/*.conf;
                location / {
                }
                error_page 404 /404.html;
                    location = /40x.html {
                }
                location /health {
                    access_log off;
                    return 200 "healthy\n";
                }
                error_page 500 502 503 504 /50x.html;
                    location = /50x.html {
                }
            }
        }
    kind: ConfigMap
    metadata:
      name: my-nginx-config
    ```


4. Create a nginx-deployment.yaml file inside `manifests/app`

    ```bash
    [admin@Laptop:~/Desktop/residency/labs/istio-nginx-lab]
    vim manifests/app/nginx-deployment.yaml


    # Copy the content below into  manifests/app/nginx-deployment.yaml
    # **Note:**
    # Replace instances of `<NAME>` with your name.


    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
      labels:
        app: nginx
      annotations:
        sidecar.istio.io/rewriteAppHTTPProbers: "true"
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: <NAME>-nginx
            image: docker.io/iahmad/ubi8-nginx-high-port:8.1
            env:
            - name: MYNAME
              value: "<NAME>"
            ports:
            - containerPort: 7000
            resources:
              requests:
                memory: "64Mi"
                cpu: "100m"
              limits:
                memory: "128Mi"
                cpu: "500m"
            livenessProbe:
              httpGet:
                path: /health
                port: 7000
              initialDelaySeconds: 5
              periodSeconds: 5
            readinessProbe:
              httpGet:
                path: /health
                port: 7000
              initialDelaySeconds: 10
              periodSeconds: 10
            volumeMounts:
            - name: my-nginx-config
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
          volumes:
            - name:  my-nginx-config
              configMap:
                name:  my-nginx-config
    ```


5. Create a service.yaml file inside `manifests/app`

    ```bash
    [admin@Laptop:~/Desktop/residency/labs/istio-nginx-lab]
    vim manifests/app/nginx-service.yaml


    # Copy the content below into manifests/app/nginx-service.yaml


    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
    spec:
      ports:
      - port: 8080
        name: http
        protocol: TCP
        targetPort: 7000
      selector:
        app: nginx
      sessionAffinity: None
      type: ClusterIP
    ```

6. Apply the configmap, deployment, and service resources you created

    ```bash
    ls ~/Desktop/residency/labs/istio-nginx-lab/manifests/app
    kubectl apply -f ~/Desktop/residency/labs/istio-nginx-lab/manifests/app -n=istio-lab
    ```

7. Make sure that the application page is reachable via a direct port forward from your laptop

    ```bash
    kubectl port-forward -n istio-lab service/nginx-service 8080:8080

    ## Access the nginx page on http://localhost:8080 to confirm service is up
    ```

8. Create a virtualservice.yaml file inside `manifests/istio`

    ```bash
    [admin@Laptop:~/Desktop/residency/labs/istio-nginx-lab]
    vim manifests/istio/nginx-virtualservice.yaml


    # Copy the content below to manifests/istio/nginx-virtualservice.yaml
    # **Note:**
    # Replace instances of `<NAME>` with your name.


    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: nginx-virtualservice
      labels:
        cluster: <NAME>
    spec:
      gateways:
      - public.istio-system.svc.cluster.local
      hosts:
      - nginx.<NAME>.bigbang.dev
      http:
      - route:
        - destination:
             host: nginx-service
             port:
                number: 8080
    ```

9. Apply the virtualservice

   ```bash
   ls ~/Desktop/residency/labs/istio-nginx-lab/manifests/istio
   kubectl apply -f ~/Desktop/residency/labs/istio-nginx-lab/manifests/istio -n=istio-lab
   kubectl get virtualservice -n=istio-lab
   kubectl get vs -n=istio-lab
   ```

10. Note: In Lab Guide #6's 6th lab where we set up ingress dns
* There is an entry for *.$NAME.bigbang.dev
* Because of the wildcard CNAME record, the DNS part of ingress was preconfigured.
* If we didn't have a wildcard CNAME entry, a new CNAME record would need to be created for every site added.

11. Access the application at the following address

  ```yaml
  https://nginx.<NAME>.bigbang.dev
  # Note: This is very similiar to how you'd setup access to a custom mission application hosted on the cluster.
  ```

**Question:**
How you were able to hit the nginx pod and service, with the gateway to ingress traffic into cluster ?

**Activity:**
Trace the traffic flow and identify AWS + K8S objects that helped display this page
