#!/bin/bash
for i in {1..50}
do
    echo "Purging pod's mem at sleep-ns-$i"
    BOOKINFO_PODS=$(kubectl get pods -n sleep-ns-$i | grep -i running | awk '{ print $1 }')
    for pod in $BOOKINFO_PODS; do
        kubectl exec $pod -n sleep-ns-$i -c istio-proxy -- /sbin/killall5 
        echo $pod "mem purged"
    done
done
BOOKINFO_PODS=$(kubectl get pod -n default | grep -i running | awk '{ print $1 }')
for pod in $BOOKINFO_PODS; do
    kubectl exec $pod -c istio-proxy -- /sbin/killall5 
    echo $pod "mem purged"
done