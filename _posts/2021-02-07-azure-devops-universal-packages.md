---
layout: post
title: Azure DevOps - Universal packages
categories: devops
tags: devops
---

```bash
az extension add --name azure-devops

az login

az artifacts universal download --organization https://dev.azure.com/NAME/
    --project="PROJECT"
    --scope project --feed binaries --name my-first-package --version 0.0.1 --path .

az artifacts universal publish --organization https://dev.azure.com/NAME/
    --project="PROJECT"
    --scope project --feed binaries --name my-first-package --version 0.0.1 --description "Welcome to Universal Packages" --path .
```