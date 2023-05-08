#!/bin/bash
for i in {1..50}
do
   echo "Deploying sleep svc at sleep-ns-$i"
   kubectl create ns sleep-ns-$i
   kubectl label ns sleep-ns-$i istio-injection=enabled --overwrite
   kubectl -n sleep-ns-$i apply -f https://raw.githubusercontent.com/istio/istio/master/samples/sleep/sleep.yaml
#    kubectl scale --replicas=3 deployment/sleep -n sleep-ns-$i
done