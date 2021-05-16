---
layout: post
title: K8s tips - Logging and Monitoring
categories: devops
tags: devops
---

# Monitor and output logs to a lile in Kubernetes

```
kubectl get pods --all-namespaces
kubectl logs <pod_name> -n <namespace_name>
kubectl logs <pod_name> -n <namespace_name> > output.log
```
