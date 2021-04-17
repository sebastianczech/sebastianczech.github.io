---
layout: post
title: K8s tips - deploying a pod to a node with a label
categories: kubernetes
tags: kubernetes
---

Documents used to deploy a pod to a node with a label:
* [Create static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)
* [Assign Pods to Nodes](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/)

Command used to achieve it:
```
kubectl get nodes --show-labels

cat <<EOF >pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - name: nginx
          containerPort: 80
          protocol: TCP
  nodeSelector:
    disk: ssd
EOF

kubectl apply -f pod.yaml 

kubectl get pods --output=wide
kubectl describe pod nginx
kubectl logs nginx

kubectl delete -f pod.yaml 
```