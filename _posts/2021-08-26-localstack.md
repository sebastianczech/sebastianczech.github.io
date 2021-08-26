---
layout: post
title: LocalStack - A fully functional local cloud stack
categories: devops
tags: devops
---

[LocalStack](https://localstack.cloud/) is a fully functional local cloud stack, which can be used to develop and test your cloud and serverless apps offline.

Installation is very simple using command:


```bash
docker run --rm -it -p 4566:4566 -p 4571:4571 --env KINESIS_PROVIDER=kinesalite --name localstack localstack/localstack
```

After that there is way to check if it starts properly:

```bash
curl http://127.0.0.1:4566/health | jq
```

```json
{
  "services": {
    "apigateway": "running",
    "cloudformation": "running",
    "cloudwatch": "running",
    "dynamodb": "running",
    "dynamodbstreams": "running",
    "ec2": "running",
    "es": "running",
    "firehose": "running",
    "iam": "running",
    "sts": "running",
    "kinesis": "running",
    "kms": "running",
    "lambda": "running",
    "logs": "running",
    "redshift": "running",
    "route53": "running",
    "s3": "running",
    "secretsmanager": "running",
    "ses": "running",
    "sns": "running",
    "sqs": "running",
    "ssm": "running",
    "events": "running",
    "stepfunctions": "running",
    "swf": "running",
    "resourcegroupstaggingapi": "running",
    "resource-groups": "running",
    "support": "running",
    "acm": "running"
  },
  "features": {
    "persistence": "disabled",
    "initScripts": "initialized"
  }
}
```

On [GitHub](https://github.com/localstack/localstack) there is described configuration and there are examples of accessing it via CLI or code. 