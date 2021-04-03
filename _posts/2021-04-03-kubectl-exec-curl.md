---
layout: post
title: K8s tips - kubectl exec curl
categories: kubernetes
tags: kubernetes
---

```
kubectl get svc SERVICE_NAME
kubectl exec busybox -- curl -s SERVICE_NAME
```