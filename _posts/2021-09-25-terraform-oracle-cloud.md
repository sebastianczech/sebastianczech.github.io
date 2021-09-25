---
layout: post
title: Oracle Cloud Infrastructure - Terraform Provider
categories: devops
tags: devops
---

To start of managing Oracle Cloud Infrastructure (OCI) using [Terraform Provider](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraform.htm) at first it's needed to install [Terraform](https://www.terraform.io/) and prepare [provider configuration](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm).

OCI Terraform provider supports three authentication methods:
- API Key Authentication
- Instance Principal Authorization
- Security Token Authentication

Enviroment variables can be set e.g. in ``.zshrc``:

```
export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1***
export TF_VAR_user_ocid=ocid1.user.oc1***
export TF_VAR_private_key_path=~/.ssh/id_rsa
```