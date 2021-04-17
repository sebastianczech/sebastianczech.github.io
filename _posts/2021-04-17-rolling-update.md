---
layout: post
title: K8s tips - performing a rolling update of an application
categories: kubernetes
tags: kubernetes
---

```
cat <<EOF | kubectl apply --record -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubeserve
spec:
  replicas: 3
  selector:
    matchLabels:
      app: kubeserve
  template:
    metadata:
      name: kubeserve
      labels:
        app: kubeserve
    spec:
      containers:
      - image: linuxacademycontent/kubeserve:v1
        name: app
EOF

kubectl rollout status deployments kubeserve

kubectl describe deployment kubeserve

kubectl scale deployment kubeserve --replicas=5

kubectl expose deployment kubeserve --port 80 --target-port 80 --type NodePort

kubectl get all

curl http:/10.106.98.113

while true; do curl http:/10.106.98.113; sleep 1; done

kubectl set image deployments/kubeserve app=linuxacademycontent/kubeserve:v2 --v 6

kubectl rollout history deployment kubeserve
```