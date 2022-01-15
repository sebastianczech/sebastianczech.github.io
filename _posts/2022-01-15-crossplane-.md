---
layout: post
title: Crossplane - universal control plane
categories: devops
tags: devops
---

[Crossplane](https://crossplane.io/) extends the Kubernetes API to manage and compose infrastructure. [Crossplane can be compared with Terraform](https://blog.crossplane.io/crossplane-vs-terraform/), but they use cloud providers API in different ways:

Terraform calls provider API: ![Terraform calls provider API](https://blog.crossplane.io/content/images/2021/03/Simple-Terraform-Stack.svg)

Crossplane provides APIs and makes updates when necessary: ![Crossplane provides APIs and makes updates when necessary:](https://blog.crossplane.io/content/images/2021/03/Simple-Crossplane-Stack.svg).

[Crossplane is an open-source project written in Go and community on Slack](https://github.com/crossplane/crossplane).