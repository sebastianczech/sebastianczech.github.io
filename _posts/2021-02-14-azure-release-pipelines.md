---
layout: post
title: Azure Release Pipeline
categories: devops
tags: devops
---

Commands from module [Create a release pipeline in Azure Pipelines](https://docs.microsoft.com/en-us/learn/modules/create-release-pipeline/):

```
git clone https://github.com/your-name/mslearn-tailspin-spacegame-web-deploy.git
git remote add upstream https://github.com/MicrosoftDocs/mslearn-tailspin-spacegame-web-deploy.git

git fetch upstream release-pipeline
git checkout -b release-pipeline upstream/release-pipeline

git commit --allow-empty -m "Trigger the pipeline"
git push origin release-pipeline

git add azure-pipelines.yml
git commit -m "Add a build stage to the pipeline"
git push origin release-pipeline

git add azure-pipelines.yml
git commit -m "Add a deployment stage to the pipeline"
git push origin release-pipeline
```