---
layout: post
title: Microsoft Foundry - network communication between an agent and an internal API
categories: azure
tags: azure, AI, networking
---

I published a new article on LinkedIn - [Microsoft Foundry - komunikacja sieciowa między agentem a wewnętrznym API](https://www.linkedin.com/pulse/microsoft-foundry-komunikacja-sieciowa-mi%C4%99dzy-agentem-czech-topce/) - about troubleshooting the case when an agent in [Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/agents/overview) needs to call an internal API exposed through [Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts).

The request path is a chain: the agent subnet → private network support for tools → DNS → the allowed domains list → APIM → the API itself. Any link can break, and the error message rarely tells you which one. On top of that, the [agent subnet cannot be changed or added to an existing Foundry account](https://learn.microsoft.com/en-us/azure/foundry/how-to/configure-private-link#limitations-and-considerations) - a change means a new account.

In the article I describe 3 cases:

1. **DNS was not the problem** - a classic agent called the tool without issues, while a new agent created from code (`azure-ai-projects` 2.x) failed with a name resolution error. The reason: at that time new agents did not route tool traffic through the private network, so the request never reached our VNet and DNS. Before touching DNS or firewall rules, check the [agent tools with network isolation](https://learn.microsoft.com/en-us/azure/foundry/how-to/configure-private-link#agent-tools-with-network-isolation) table.
2. **Outbound restrictions** - with `restrictOutboundNetworkAccess` enabled, the MCP server behind APIM was blocked, because `allowedFqdnList` contained only Key Vault. The fix was adding the exact APIM gateway host - matching is strict and changes take up to ~15 minutes ([data loss prevention](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-data-loss-prevention)).
3. **The 424 error** - fetching tools from the [MCP server](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/model-context-protocol) returned HTTP 424 with `CustomerManagedDownstreamError`. Foundry wraps the 403 from the APIM gateway, and the real cause (missing / mismatched custom headers) was only visible in the `innerReasonPhrase` field. Headers can be passed via a **Custom keys** connection in the project or directly in the tool definition - the first option is more convenient, as the second requires a new agent version for every change.

Diagnostics are best done along the chain: check tool support for your agent type, `nslookup` and `curl` from a VM in the same VNet, the allowed domains list, APIM traces and finally Application Insights. Useful tools: a simple test script using the same headers as the agent and [MCP Inspector](https://github.com/modelcontextprotocol/inspector). Working examples with Bicep can be found in [foundry-samples - 19-private-network-agent-tools](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/19-private-network-agent-tools).
