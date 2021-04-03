---
layout: post
title: K8s tips - create cluster with kubeadm
categories: kubernetes
tags: kubernetes
---

```
kubeadm init --pod-network-cidr=10.0.1.0/24
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

kubeadm join $IP:6443 --token $TOKEN --discovery-token-ca-cert-hash $HASH
kubectl get nodes

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

kubectl get nodeskubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
kubectl get nodes
```