---
layout: post
title: Microsoft Azure User Group Poland - Meetup - 2026-09-16
categories: Azure
tags: Azure, AI
---

Today I had the pleasure to attend the [[WAW] 83rd Microsoft Azure User Group Poland meeting in Warsaw](https://www.meetup.com/pl-pl/microsoft-azure-users-group-poland/events/316370317/), which opened the autumn season. There were 3 presentations, I stayed for the first two.

## *Gdzie postawić agenta w Azure?* - Łukasz Kałużny

The starting point was a simple definition - `agent = model + tools + context` - and the loop it runs in (*think → tools → observation → response*), triggered by a human, a cron, an event or an API call.

The main takeaway: **an agent is just a microservice** - a regular application or an event-driven worker. Its state is a database, while tools and the LLM are simply APIs it calls. From that angle, "where to host an agent" is the same question we ask about any other service:

- [Logic Apps - agent loop](https://learn.microsoft.com/en-us/azure/logic-apps/agent-workflows-concepts)
- [Microsoft Foundry - prompt agents](https://learn.microsoft.com/en-us/azure/foundry/agents/overview) and [hosted agents](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents)
- [App Service](https://learn.microsoft.com/en-us/azure/app-service/overview)
- [Durable Functions](https://learn.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview) with [Durable Task Scheduler](https://learn.microsoft.com/en-us/azure/azure-functions/durable/durable-task-scheduler/durable-task-scheduler) and [Durable Task for AI agents](https://learn.microsoft.com/en-us/azure/durable-task/sdks/durable-task-for-ai-agents)
- [Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview), including [dynamic sessions](https://learn.microsoft.com/en-us/azure/container-apps/sessions) for running LLM-generated code safely
- [AKS](https://learn.microsoft.com/en-us/azure/aks/what-is-aks), with [KEDA](https://keda.sh/) and [Dapr Agents](https://github.com/dapr/dapr-agents) for event-driven scaling

An important note about frameworks such as [Microsoft Agent Framework](https://github.com/microsoft/agent-framework): **they are building blocks, not a finished product**.

Logic Apps got a lot of attention, as they can act as an A2A server, an [MCP tool](https://learn.microsoft.com/en-us/azure/logic-apps/set-up-model-context-protocol-server-standard), a knowledge base, or a workflow calling other workflows.

A separate thread was web search. The Bing Search API is effectively frozen and the only way forward is [Grounding with Bing Search](https://learn.microsoft.com/en-us/azure/ai-foundry/agents/how-to/tools/bing-grounding), which is really just a billing object. Worth remembering: data leaves the Azure compliance boundary, the service works on a cached copy of the internet, and it is hard to debug because you cannot see what goes in and what comes out.

The closing punchline - **the Death Star is back, this time with an LLM** - about the risk of building one huge monolith around agents again.

## *Subscription Vending Machine: jak oddać Azure w ręce zespołów i nie stracić nad tym kontroli* - Krzysztof Polewiak

The second talk was about automating Azure subscription creation, so that teams can get subscriptions in a self-service way while staying within organizational standards. It was demonstrated with [ChrisPolewiak/AzureSubscriptionVending](https://github.com/ChrisPolewiak/AzureSubscriptionVending).

The solution is an Azure DevOps pipeline that validates inputs, bootstraps a resource group and a user-assigned managed identity with [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) and [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/), configures RBAC, optionally creates a service connection with OIDC authentication, and finally moves the subscription into the target management group.

More on the topic:

- [Subscription vending](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
- [Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)
- [Management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- [Workload identity federation for Azure DevOps service connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure)

The third talk - *5 lat czy 27 dni? Disaster Recovery za rozsądne pieniądze...* by Kamil Mrzygłód - I unfortunately had to miss.
