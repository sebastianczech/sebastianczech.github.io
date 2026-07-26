---
layout: post
title: Azure - learning without costs
categories: azure
tags: azure, devops
---

When learning the Azure cloud, as in any other field, it is important to know not only the theoretical basics, but above all how to apply the acquired knowledge in practice. For that purpose, [you can use the free services available in Azure](https://azure.microsoft.com/en-us/pricing/free-services). Apart from that, it is possible to use other solutions, which I list in the table below, i.e. emulators and tools run locally on your workstation. This is also an environment that can be used in a CI/CD pipeline to test infrastructure. You have to remember, however, that the solutions below do not reproduce cloud features 100%, but for testing or learning they will certainly do the job.

| Service | Tool | Description |
|---|---|---|
| **Storage** (Blob / Queue / Table) | [Azurite](https://github.com/Azure/Azurite) | A lightweight emulator written in Node.js. |
| **Cosmos DB** | [Azure Cosmos DB emulator](https://learn.microsoft.com/azure/cosmos-db/emulator) | A local NoSQL database with Data Explorer, also available as a Linux version in a container (vNext). |
| **Service Bus** | [Service Bus emulator](https://learn.microsoft.com/azure/service-bus-messaging/overview-emulator) | Queues and topics run as a Docker container. |
| **Event Hubs** | [Event Hubs emulator](https://learn.microsoft.com/azure/event-hubs/overview-emulator) | Event streaming locally, with support for the Kafka and AMQP protocols, run as a Docker container. |
| **Functions** | [Azure Functions Core Tools](https://learn.microsoft.com/azure/azure-functions/functions-run-local) | The full Azure Functions runtime run locally, with triggers and bindings. |
| **API Management** | [Self-hosted gateway](https://learn.microsoft.com/azure/api-management/self-hosted-gateway-overview) | An APIM gateway running locally / in a container. |

Besides the emulators listed above, it is also worth taking a look at [LocalStack for Azure](https://docs.localstack.cloud/azure/), which lets you test infrastructure code without physically deploying it in the cloud. Unlike the other entries, however, it is not a fully free solution — running the emulator requires an account and a token (`LOCALSTACK_AUTH_TOKEN`).

So there are quite a few options for learning and testing the infrastructure you are building without paying for the cloud — it is worth using them.
