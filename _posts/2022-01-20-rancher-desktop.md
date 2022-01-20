---
layout: post
title: Rancher Desktop - Kubernetes and container management on the desktop
categories: devops
tags: devops
---

[Rancher Desktop](https://rancherdesktop.io/) provides Kubernetes and container management for Mac, Windows and Linux. Moreover it gives the ability to build, push, and pull images via the [nerdctl](https://github.com/containerd/nerdctl) project, which we can use to check namespaces and images downloaded just after installing Rancher Desktop:

```
> nerdctl namespace ls
NAME        CONTAINERS    IMAGES    VOLUMES
buildkit    0             0         0
k8s.io      22            16        0

> nerdctl images --namespace k8s.io
REPOSITORY                          TAG                                                                 IMAGE ID        CREATED         PLATFORM       SIZE
rancher/klipper-helm                v0.6.6-build20211022                                                967badd1821e    21 hours ago    linux/arm64    219.0 MiB
rancher/klipper-lb                  v0.3.4                                                              712642fec5a4    21 hours ago    linux/arm64    7.9 MiB
rancher/local-path-provisioner      v0.0.20                                                             4cef81bc7b7c    21 hours ago    linux/arm64    31.5 MiB
rancher/mirrored-coredns-coredns    1.8.4                                                               6fceeddebb34    21 hours ago    linux/amd64    42.7 MiB
rancher/mirrored-library-busybox    1.32.1                                                              6b2354414139    21 hours ago    linux/arm64    0.0 B
rancher/mirrored-library-traefik    2.5.0                                                               01ca9285870b    21 hours ago    linux/arm64    94.1 MiB
rancher/mirrored-metrics-server     v0.5.0                                                              9b58356dfb76    21 hours ago    linux/amd64    59.8 MiB
rancher/mirrored-pause              3.1                                                                 9fb73d128d41    21 hours ago    linux/amd64    520.0 KiB
sha256                              11d994ce6bfaa93ba5d734815d5609750c2067d0df8b74abf33516ceb4c4ad5f    0979d6267ee3    21 hours ago    linux/arm64    31.5 MiB
sha256                              2a3d4686b4031779b6f4d38149c08487a9e859d91c73aaffbd98caded91b768d    6b2354414139    21 hours ago    linux/arm64    0.0 B
sha256                              3b7ad2a8ddb966ceac29bb1513fdc9a3315dc3cc66e62e3b977ab48609f62496    69ba0980a284    21 hours ago    linux/arm64    219.0 MiB
sha256                              625882d9991e41d98c4b3d51384d1c8dd99cc36246a81cbfbbdadb9b7828ff3f    ba125a6042e5    21 hours ago    linux/arm64    7.9 MiB
sha256                              6cf7c80fe4444767f63116e6855bf8c90bddde8ef63d3a2dc9b86c74989a4eb5    ce553ebde39a    21 hours ago    linux/amd64    520.0 KiB
sha256                              6d3ffc2696ac2b3f9240339c6b85f698ddb3fadcabb0619d749f42b617e96d70    0e409a08432b    21 hours ago    linux/amd64    42.7 MiB
sha256                              8479f0715ebb5225f00ed07a54d38230c38685ce2ad6d98e078d43d71a1ccf23    8a718325f4c5    21 hours ago    linux/arm64    94.1 MiB
sha256                              ee11f1e38ac66c96e91e9504296e77a57733101b02a678c901f5fe9d1d332354    1a89693d2093    21 hours ago    linux/amd64    59.8 MiB
```

Using [Dockerfile](https://github.com/sebastianczech/Cloud-Native-CI-CD/blob/main/app/Dockerfile) for simple [application](https://github.com/sebastianczech/Cloud-Native-CI-CD) image can be built:

```
> nerdctl build --tag python-localstack-client -f app/Dockerfile .

> nerdctl namespace ls
NAME        CONTAINERS    IMAGES    VOLUMES
buildkit    0             0         0
default     0             1         0
k8s.io      22            16        0

> nerdctl images
REPOSITORY                  TAG       IMAGE ID        CREATED           PLATFORM       SIZE
python-localstack-client    latest    90019635255f    20 seconds ago    linux/arm64    300.3 MiB
```

Then container in Rancher Desktop can be started:

```
> nerdctl run --name python-localstack-client --rm python-localstack-client

> nerdctl ps -a
CONTAINER ID    IMAGE                                                COMMAND                   CREATED           STATUS    PORTS    NAMES
cb0d476cc546    docker.io/library/python-localstack-client:latest    "python3 main_boto3.…"    10 seconds ago    Up                 python-localstack-client
```