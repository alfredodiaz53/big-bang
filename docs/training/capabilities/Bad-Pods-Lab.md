# Bad Pods Lab
## Lab Overview
> In this lab we will create various `bad-pods` with an intentional errors and then debug these `bad-pods`  
> Next we will cover how to take a node out of service for maintenance without disturbing our workloads.



# Lab: Deployments and Configmaps

> Note: sshuttle is expecte to be running in a background  
`sshuttle -vr bastion --dns 10.10.0.0/16 --ssh-cmd 'ssh -i ~/.ssh/bb-onboarding-attendees.ssh.privatekey'`

## Intro

In this lab you will be introduced to some error scenarios and learn how to troubleshoot issues with  your kubenetes cluster.

Recall from the slide presentation that a Deployment API object *orchestrates* the lifecycle management of a pod on behalf of a user. A ConfigMap API object is an API object containing external configuration values in a key/value pair format. It is treated as a "volume" and "mounted" to a pod in kubernetes.

## Experience Gained

* Debug pod creation failures
* Debug pod crashes
* Node maintanence scenario

## Debug pod creation failures

1. Navigate to the `day1refresher` folder

```bash
cd ~/day1refresher
```

2. Create a file called `bad-pod.yaml` Paste the following into it:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod
spec:
  containers:
  - name: fail
    image: busybox:training-fail
    tty: true
    command:
    - cat
```

3. Run the following command to create the pod:

```bash
kubectl apply -f bad-pod.yaml -n=refresher
```

4. Let’s watch the various pod transitions:

```bash
kubectl get pods --watch -n=refresher
```

**You will see a set of transitions like ErrImagePull and ImagePullBackOff as show below**

```bash
NAME      READY   STATUS         RESTARTS   AGE
bad-pod   0/1     ErrImagePull   0          3s
bad-pod   0/1     ImagePullBackOff   0          15s
bad-pod   0/1     ErrImagePull       0          28s
```

5. Let’s stop watching and describe the pod to see if we can figure out what is happenning:

```bash
Ctrl-C
kubectl describe pod bad-pod -n=refresher |  grep -A25 Events:
```
**In the `Events` section of the output you will see indicators of a problem downloading the image as seen below**

6. Let’s delete the pod and try attempt to fix the image being pulled:

```bash
kubectl delete -f bad-pod.yaml -n=refresher
vi bad-pod.yaml
```

**Replace `busybox:training-fail` to `busybox` and then save**

7. Let’s create the pod and watch the pod again:

```bash
kubectl apply -f bad-pod.yaml -n=refresher
kubectl get pods --watch -n=refresher
```

**The pod should be successfully created now**

```bash
NAME      READY   STATUS    RESTARTS   AGE
bad-pod   1/1     Running   0          11m
```

8. Lets clean up and delete the pod :

```bash
kubectl delete -f bad-pod.yaml -n=refresher
```

## Debug pod crashes

1. Let’s create a pod that will continually restart because it exits with a non-zero exit code. 

2. Create a file called `crash-loop.yaml` Paste the following into it:

```bash
vi crash-loop.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: crash-loop
spec:
  containers:
  - name: fail
    image: busybox
    command:
    - sh
    - -c
    - sleep 10 && exit 1
```

3. Deploy the pod:

```bash
kubectl apply -f crash-loop.yaml -n=refresher
```

4. Let’s watch the various pod transitions

```bash
kubectl get pods --watch -n=refresher
```

**Notice how after a few Running/Error transitions the pod goes into CrashLoopBackoff and the run time is delayed as shown below**

```bash
NAME         READY   STATUS              RESTARTS   AGE
crash-loop   0/1     ContainerCreating   0          3s
crash-loop   1/1     Running             0          4s
crash-loop   0/1     Error               0          14s
crash-loop   1/1     Running             1          15s
crash-loop   0/1     Error               1          25s
crash-loop   0/1     CrashLoopBackOff    1          37s
crash-loop   1/1     Running             2          39s
crash-loop   0/1     Error               2          49s
crash-loop   0/1     CrashLoopBackOff    2          60s
```

5. Lets stop watching and delete the pod:

```bash
Ctrl+C
kubectl delete -f crash-loop.yaml -n=refresher
```

6. Lets fix the pod command definition: 

```bash
vi crash-loop.yaml
```
**Replace `- sleep 10 && exit 1` with `- echo Container 1 is Running && sleep 3600` and then save**

7. Let’s create the pod and watch the pod again:

```bash
kubectl apply -f crash-loop.yaml -n=refresher
kubectl get pods --watch -n=refresher
```

**The pod should be successfully created now**

8. Lets clean up and delete the pod :

```bash
kubectl delete -f crash-loop.yaml -n=refresher
```
## Node maintanence scenario

1. Let’s create a deployment:

```bash
kubectl create deployment maintenance-lab --image=gcr.io/google-samples/node-hello:1.0 -n=refresher
```

2. Find the node for this pod:

```bash
kubectl get pods -o wide -n=refresher
# You'll see a few columns one will have NODE and list the name of the node the pod is running on
```
**Copy the value under the Node column for later reference.**
> Our node names look like this:  
> `ip-10-10-1-17.us-gov-west-1.compute.internal`  

3. We need to perform some ‘maintenance’ on this node.  Let’s make sure no more pods can be scheduled to it:

```bash
kubectl cordon node-name -n=refresher
# EX: kubectl cordon ip-10-10-1-17.us-gov-west-1.compute.internal
# node-name will be the name of the kubernetes node that the 
# pod that is part of the maintenance-lab deployment is running on
```

**The output should be something like**

```bash
node/ip-10-10-58-44.us-gov-west-1.compute.internal cordoned
```

4. Describe the cordoned node:

```bash
kubectl describe node <cordoned node: e.g `ip-10-10-58-44.us-gov-west-1.compute.internal`>
```

**Examine the output and look for the Taints towards the top of the output.  You will see this:  node.kubernetes.io/unschedulable:NoSchedule as shown below**

```bash
Events:
  Type    Reason              Age    From     Message
  ----    ------              ----   ----     -------
  Normal  NodeNotSchedulable  5m27s  kubelet  Node ip-10-10-58-44.us-gov-west-1.compute.internal status is now: NodeNotSchedulable
```


5. List out the nodes:

```bash
kubectl get nodes
```

**Notice the status of the node includes SchedulingDisabled as shown below**

```bash
NAME                                            STATUS                     ROLES         AGE     VERSION
ip-10-10-3-88.us-gov-west-1.compute.internal    Ready                      <none>        3d22h   v1.18.12+rke2r2
ip-10-10-55-57.us-gov-west-1.compute.internal   Ready                      etcd,master   3d22h   v1.18.12+rke2r2
ip-10-10-58-44.us-gov-west-1.compute.internal   Ready,SchedulingDisabled   <none>        3d22h   v1.18.12+rke2r2
ip-10-10-83-95.us-gov-west-1.compute.internal   Ready                      <none>        3d22h   v1.18.12+rke2r2
```

6. Let’s move the maintenance lab workload to the other node:

```bash
kubectl drain node-name --ignore-daemonsets
```
**This step might take a few minutes. Notice that pod/maintenance-lab has been moved as shown below**

```bash
node/ip-10-10-58-44.us-gov-west-1.compute.internal already cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-proxy-t75c7, kube-system/rke2-canal-78ctm
evicting pod default/maintenance-lab-54545b884b-8j5rj
pod/maintenance-lab-54545b884b-8j5rj evicted
node/ip-10-10-58-44.us-gov-west-1.compute.internal evicted
```

7. Look at the node for our maintenance-lab pod:

```bash
kubectl get pods -o wide -n refresher
```
**Notice that it is now running on the other node.**
```bash
NAME                               READY   STATUS    RESTARTS   AGE   IP          NODE                                            NOMINATED NODE   READINESS GATES
maintenance-lab-54545b884b-n26db   1/1     Running   0          10m   10.42.2.4   ip-10-10-83-95.us-gov-west-1.compute.internal   <none>           <none>
```

8. Uncordon the node and look at the nodes again

```bash
kubectl uncordon node-name
```

```bash
node/ip-10-10-58-44.us-gov-west-1.compute.internal uncordoned
NAME                                            STATUS   ROLES         AGE     VERSION
ip-10-10-3-88.us-gov-west-1.compute.internal    Ready    <none>        3d22h   v1.18.12+rke2r2
ip-10-10-55-57.us-gov-west-1.compute.internal   Ready    etcd,master   3d22h   v1.18.12+rke2r2
ip-10-10-58-44.us-gov-west-1.compute.internal   Ready    <none>        3d22h   v1.18.12+rke2r2
ip-10-10-83-95.us-gov-west-1.compute.internal   Ready    <none>        3d22h   v1.18.12+rke2r2
```

9. Clean up and delete the deployment and refresher namespace:

```bash
kubectl delete deployment maintenance-lab -n=refresher
# deployment.apps "maintenance-lab" deleted
kubectl delete namespace refresher
```

### Lab Summary

You have been able to successfully troubleshoot issues with pod creation and inspect the lifecyle to infer underlying issues that were preventing a pod for getting created and/or stuck in a crash loop.

You also ran a typical maintenance scenario where you cordoned off a node and then drained that node off any workloads it was running. After performing some maintenance such as upgrades or repairs you have uncordoned the node so that it back available to run workloads.
