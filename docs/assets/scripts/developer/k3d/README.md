# K3d Developer

Calico yaml needs to be updated with k3d

```
curl -L https://k3d.io/v5.5.1/usage/advanced/calico.yaml -O > calico.yaml
```

BB k3d dev uses the 172.21.0.0/16 cidr subnet for pods, so `CALICO_IPV4POOL_CIDR` needs to match:
 
```
- name: CALICO_IPV4POOL_CIDR
  value: "172.21.0.0/16"
```
