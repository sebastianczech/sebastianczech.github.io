---
layout: post
title: K8s tips - installing and testing
categories: kubernetes
tags: kubernetes
---

Installing instructions:
* [Docker](https://docs.docker.com/engine/install/ubuntu/)
* [Kubernetes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
* [Calico](https://docs.projectcalico.org/getting-started/kubernetes/quickstart)


Initialize master:
```
kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

Join worker nodes:
```
kubeadm join 10.0.1.101:6443 --token *** \
    --discovery-token-ca-cert-hash ***
```

Create simple deployment
```
kubectl create deployment nginx --image=nginx
kubectl get pods
```

Forward port and check it using curl:
```
kubectl port-forward nginx-6799fc88d8-dlm4k 8081:80

curl -I http://127.0.0.1:8081
HTTP/1.1 200 OK
Server: nginx/1.19.9
Date: Tue, 06 Apr 2021 20:03:48 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 30 Mar 2021 14:47:11 GMT
Connection: keep-alive
ETag: "606339ef-264"
Accept-Ranges: bytes
```

Check version of nginx:
```
kubectl exec -it nginx-6799fc88d8-dlm4k -- nginx -v
```

Expose deployment and check it:
```
kubectl expose deployment nginx --port 80 --type NodePort
kubectl get svc

kubectl get pod -o wide
curl -I ip-10-0-1-102:32242
```