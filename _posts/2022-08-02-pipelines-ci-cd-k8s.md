---
layout: post
title: CI/CD pipelines for Kubernetes
categories: devops, iaac
tags: devops, iaac
---

* [Kubernetes Deployment: From Basic Strategies to Progressive Delivery](https://codefresh.io/learn/kubernetes-deployment/)
* [Continuous Blue-Green Deployments With Kubernetes](https://semaphoreci.com/blog/continuous-blue-green-deployments-with-kubernetes)
* [Debug Running Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)
* CI/CD tools:
  * build images:
    * Docker
    * Kaniko
    * Cloud Native Buildpacks
  * testing:
    * Trivy
    * container-structure-test
    * Grype
    * kube-score
  * deployment:
    * Kubectl
    * Skaffold
    * GitOps:
      * ArgoCD
      * Flux
  * manifests:
    * Helm Charts
    * Kustomize
* 5 tips:
  * build pipelines executed from command line
  * use CI/CD engine as a orchestrator, not a platform
  * use proper tools in correct versions
  * everything as a code
  * CI/CD has to be boring, but extensible
* CI/CD engines:
  * Gitlab CI
  * GitHub actions
  * Azure DevOps
  * Jenkins
  * Tekton
  * Circle CI
  * Travis
* 4 functions of CI/CD engine:
  * triggers
  * secrets / tokens (vault)
  * visibility what is happening (user interface)
  * tools (building image, deployment, tests)