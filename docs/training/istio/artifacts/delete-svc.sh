#!/bin/bash
for i in {1..50}
do
   echo "Deleting sleep svc at sleep-ns-$i"
   kubectl delete svc sleep -n sleep-ns-$i
   kubectl delete deployment sleep -n sleep-ns-$i
   kubectl delete ns sleep-ns-$i --force
done