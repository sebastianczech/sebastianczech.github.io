---
layout: post
title: K8s tips - create cluster with kubeadm
categories: kubernetes
tags: kubernetes
---

Disable SELinux:
```
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

Enable br_netfilter:
```
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
```

Set the cgroup driver for Docker to systemd, reload systemd, then enable and start Docker:
```
sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker --now
```

Enable kubelet:
```
systemctl enable kubelet
```

Initialize the cluster using the IP range for Flannel:
```
kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Join nodes to master:
```
kubeadm join 10.0.1.100:6443 --token bq6idp.5le6s22jm8674rgh \
    --discovery-token-ca-cert-hash ******
```

Create and scale deployment:
```
kubectl create deployment nginx --image=nginx
kubectl scale deployment nginx --replicas=4
kubectl get pods
```