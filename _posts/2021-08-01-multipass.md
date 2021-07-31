---
layout: post
title: Multipass - Ubuntu VMs on demand for any workstation
categories: devops
tags: devops
---

[Multipass](https://multipass.run/) - step by step:

```
sudo multipass set local.driver=virtualbox
sudo multipass set local.driver=hyperkit

sudo multipass set client.gui.autostart=off
multipass set client.gui.autostart=false

multipass list

multipass launch -n node1
multipass launch -n node1 --cloud-init node1-cloud-config.yaml

multipass info node1
multipass start --all

multipass shell node1
multipass exec node1 -- lsb_release -a

multipass stop node1
multipass delete node1
multipass purge
```
