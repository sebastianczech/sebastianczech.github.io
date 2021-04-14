---
layout: post
title: K8s tips - creating a service and discovering DNS names in Kubernetes
categories: kubernetes
tags: kubernetes
---

```
kubectl run nginx --image=nginx
kubectl get deployments

kubectl expose deployment nginx --port 80 --type NodePort
kubectl get services

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - image: busybox:1.28.4
    command:
      - sleep
      - "3600"
    name: busybox
  restartPolicy: Always
EOF

kubectl get pods

kubectl exec busybox -- nslookup nginx
```