---
layout: post
title: Terraform & tests
categories: devops, iaac
tags: devops, iaac
---

# Build infrastructure as a code (IaC) using test-later development (TLD) method

Using test-driven development (TDD) approach in software development is broadly used in industry for many years. When we are talking about infrastructure, it's not as obvious and frequently used approach, but when we take a look on [pyramid of tests](https://www.hashicorp.com/blog/testing-hashicorp-terraform) and think about tools available for infrastructure as a code (IaC), then we can propose multiple approaches to do:
- unit tests using built-in tools available e.g. in Terraform like ``terraform fmt``, ``terraform validate`` or external programs like [conftest](https://www.conftest.dev/)
- contract tests using [validations for variables](https://www.terraform.io/language/values/variables), [lifecycle pre-conditions for resources](https://www.terraform.io/language/expressions/custom-conditions) or external tools like [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform)
- integration tests using [``terratest``](https://terratest.gruntwork.io/), [``localstack``](https://localstack.cloud/) or other local / non-production environments
- end-to-end tests using also [``terratest``](https://terratest.gruntwork.io/)

As we have a lot of types of tests, we have also different approaches when and how to write them. In case of TDD there is common cycle - writing failing test (red phase), implementing code which causes that tests is succeeding (green phase) and adjusting code (refactor phase). For infrastructure sometimes it's very hard to write tests before implementation e.g. validation rule variable can be created after variable is defined, not before, that's why in many cases for IaC we can talk about test-later development (TLD) method.

Are you interested how to do every type of test in practice (live demo) ?
Are you interested in answer for question *is the TLD harmful while doing IaC* ? 

# Links
* [Unit tests](https://www.terraform.io/cdktf/test/unit-tests)
* [Conftest](https://www.conftest.dev/)
* [Module testing](https://www.terraform.io/language/modules/testing-experiment)
* [Terratest - automated tests for infrastructure code](https://terratest.gruntwork.io/)
* [Kitchen-Terraform - verification of infrastructure](https://github.com/newcontext-oss/kitchen-terraform)
* [Terratest - testing best practices](https://terratest.gruntwork.io/docs/#testing-best-practices)
* [Terraform Validator](https://github.com/GoogleCloudPlatform/terraform-validator)
* [tfsec](https://github.com/aquasecurity/tfsec)
* [kube-score](https://kube-score.com/)
* [Infracost](https://www.infracost.io/)
* [Test-Driven Development (TDD) for Infrastructure](https://www.hashicorp.com/resources/test-driven-development-tdd-for-infrastructure)
* [Testing HashiCorp Terraform](https://www.hashicorp.com/blog/testing-hashicorp-terraform)
* [Testing your HCL Modules in Terraform](https://www.hashicorp.com/resources/testing-your-hcl-modules-in-terraform)
* [Testing Infrastructure as Code on Localhost](https://www.hashicorp.com/resources/testing-infrastructure-as-code-on-localhost)
* [How to Test Terraform Infrastructure Code](https://winder.ai/how-to-test-terraform-infrastructure-code/)
* [Terraform with Terratest in Gitlab Pipeline](https://www.infralovers.com/en/articles/2019/12/18/terraform-with-terratest-in-gitlab-pipeline/)
* [Design by Contract in Terraform](https://betterprogramming.pub/design-by-contracts-in-terraform-63467a749c1a)
* [Test-Driven Development for Infrastructure](https://medium.com/@joatmon08/test-driven-development-techniques-for-infrastructure-a73bd1ab273b)
* [Example with Terraform / AWS / S3](https://github.com/joatmon08/tdd-infrastructure/tree/main/tf-aws-s3)
* [Examples for Test-Driven Development (TDD) of infrastructure.](https://github.com/joatmon08/tdd-infrastructure)
* [Test-later development (TLD) - writing unit test after writing code considered harmful in test-driven development](https://opensource.com/article/20/2/automate-unit-tests)
* [TDD vs TLD and what is the minimum code coverage needed](https://medium.com/swlh/tdd-vs-tld-and-what-is-the-minimum-code-coverage-needed-f380181d3400)