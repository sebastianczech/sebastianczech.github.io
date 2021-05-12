---
layout: post
title: K8s tips - smoke testing a Kubernetes cluster
categories: devops
tags: devops
---

# Verify the cluster's ability to perform data encryption.

```
kubectl create secret generic kubernetes-the-hard-way --from-literal="mykey=mydata"

sudo ETCDCTL_API=3 etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem\
  /registry/secrets/default/kubernetes-the-hard-way | hexdump -C
```

# Verify that deployments work.

```
kubectl run nginx --image=nginx

kubectl get pods -l run=nginx
```

# Verify that remote access works via port forwarding.

```
POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward $POD_NAME 8081:80

curl --head http://127.0.0.1:8081
```

# Verify that you can access container logs with kubectl logs.

```
POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")

kubectl logs $POD_NAME
```

# Verify that you can execute commands inside a container with `kubectl exec`.

```
kubectl exec -ti $POD_NAME -- nginx -v
```

# Verify that services work.

```
kubectl expose deployment nginx --port 80 --type NodePort

NODE_PORT=$(kubectl get svc nginx --output=jsonpath='{range .spec.ports[0]}{.nodePort}')

curl -I 10.0.1.102:$NODE_PORT
```
