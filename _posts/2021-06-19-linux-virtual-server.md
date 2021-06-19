---
layout: post
title: Install and Configure Linux Virtual Server (LVS) for Load Balancing
categories: devops
tags: devops, linux
---

# Load the IPVS kernel module.

```
sudo -i
modprobe ip_vs
lsmod | grep ip_vs
```

# Install the IPVS administration utility package.

```
yum -y install ipvsadm
```

# Enable packet forwarding and non-local IP address binding.

```
vim /etc/sysctl.conf

net.ipv4.ip_forward = 1
net.ipv4.ip_nonlocal_bind = 1

sysctl -p
```

# Start up the `ipvsadm` service and ensure that it persists through reboot.

```
touch /etc/sysconfig/ipvsadm
systemctl enable ipvsadm
systemctl start ipvsadm
```

# Configure the virtual service and specify the scheduling algorithm.

```
ipvsadm -A -t 10.0.1.50:80 -s rr
```

# Add the real servers to the virtual service and specify a packet forwarding method.

```
ipvsadm -a -t 10.0.1.50:80 -r 10.0.1.100:80 -m
ipvsadm -a -t 10.0.1.50:80 -r 10.0.1.200:80 -m

ipvsadm -l -n

curl http://10.0.1.50
```