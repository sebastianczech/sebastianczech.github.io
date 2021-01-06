---
layout: post
title: Terragrunt
categories: terraform
tags: terraform
---

[Terragrunt](https://terragrunt.gruntwork.io/) is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state. Using Terragrunt you can run one command for all modules instead executing it in each module independently e.g.:

```bash
terragrunt plan-all
terragrunt apply-all
terragrunt destroy-all
terragrunt output-all
```