---
layout: post
title: K8s tips - setting up Kubernetes networking with Weave Net
categories: devops
tags: devops, kubernetes
---

# Enable IP Forwarding on All Worker Nodes

```
sudo sysctl net.ipv4.conf.all.forwarding=1

echo "net.ipv4.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.conf
```

# Install Weave Net in the Cluster

```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.200.0.0/16"

kubectl get pods -n kube-system

cat << EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx
   spec:
     selector:
       matchLabels:
         run: nginx
     replicas: 2
     template:
       metadata:
         labels:
           run: nginx
       spec:
         containers:
         - name: my-nginx
           image: nginx
           ports:
           - containerPort: 80
EOF

kubectl expose deployment/nginx

kubectl run busybox --image=radial/busyboxplus:curl --command -- sleep 3600
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

kubectl get ep nginx

kubectl exec $POD_NAME -- curl 10.200.0.2
kubectl exec $POD_NAME -- curl 10.200.192.1

kubectl get svc

kubectl exec $POD_NAME -- curl 10.32.0.205
```
