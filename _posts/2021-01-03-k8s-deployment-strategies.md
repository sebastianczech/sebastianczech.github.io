---
layout: post
title: Kubernetes deployment strategies
categories: kubernetes
tags: kubernetes
---

[Kubernetes deployment strategies](https://github.com/ContainerSolutions/k8s-deployment-strategies):
* **recreate**: terminate the old version and release the new one
* **ramped**: release a new version on a rolling update fashion, one after the other
* **blue/green**: release a new version alongside the old version then switch traffic
* **canary**: release a new version to a subset of users, then proceed to a full rollout
* **a/b testing**: release a new version to a subset of users in a precise way (HTTP headers, cookie, weight, etc.). This doesn’t come out of the box with Kubernetes, it imply extra work to setup a smarter loadbalancing system (Istio, Linkerd, Traeffik, custom nginx/haproxy, etc).
* **shadow**: release a new version alongside the old version. Incoming traffic is mirrored to the new version and doesn't impact the response.