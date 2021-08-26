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
    "dynamodb": "starting",
    "dynamodbstreams": "starting",
    "ec2": "starting",
    "es": "starting",
    "firehose": "starting",
    "iam": "starting",
    "sts": "starting",
    "kinesis": "starting",
    "kms": "starting",
    "lambda": "starting",
    "logs": "starting",
    "redshift": "starting",
    "route53": "starting",
    "s3": "starting",
    "secretsmanager": "starting",
    "ses": "starting",
    "sns": "starting",
    "sqs": "starting",
    "ssm": "starting",
    "events": "starting",
    "stepfunctions": "starting",
    "swf": "starting",
    "resourcegroupstaggingapi": "starting",
    "resource-groups": "starting",
    "support": "starting",
    "acm": "running"
  }
}
```

On [GitHub](https://github.com/localstack/localstack) there is described configuration and there are examples of accessing it via CLI or code. 