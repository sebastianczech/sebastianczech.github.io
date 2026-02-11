---
layout: post
title: Virtual network routing appliance (Azure)
categories: devops, cloud
tags: devops, cloud
---

[Azure Virtual Network Routing Appliance (VNRA)](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-routing-appliance-overview) is a new managed, Azure-native network routing device currently in **public preview**. Unlike traditional hub-and-spoke architectures that rely on VM-based network virtual appliances, VNRA runs on specialized networking hardware, acting as a high-performance forwarding layer for virtual networks.

## Key benefits

- **High throughput & low latency** - eliminates forwarding bottlenecks common in hub-spoke topologies
- **Horizontal scaling** - scales routing capacity up to 200 Gbps configurable bandwidth
- **East-west traffic acceleration** - optimized for traffic flows between spokes
- **Availability zone resilience** - built-in high availability by default, no load balancer required
- **Azure-native management** - managed as a top-level Azure resource via familiar tools (RBAC, governance)

## How it works

VNRA is deployed in a dedicated subnet named `VirtualNetworkApplianceSubnet` within a virtual network. It acts as the forwarding layer for routed traffic, replacing the need for VM-based NVAs and their associated load balancers. This approach removes the performance ceiling imposed by VM SKUs and simplifies the network architecture.

## Context: NVAs in Azure networking

To understand where VNRA fits, it helps to look at how NVAs are used today. A practical example is described in the article [Azure VMware Solution with vWAN Routing Intent and Palo Alto Cloud NGFW](https://techcommunity.microsoft.com/blog/itopstalkblog/azure-vmware-solution-with-vwan-routing-intent-and-palo-alto-cloud-ngfw/4062629), which demonstrates a hub-and-spoke architecture where a Virtual WAN hub with Palo Alto Cloud NGFW acts as a central inspection and routing point.

In that architecture:
- The vWAN hub advertises default RFC 1918 addresses (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) to all connected networks
- All inter-network traffic is forced through the hub's security appliance for inspection
- AVS connects via ExpressRoute with NSX-T Tier-0 learning routes via BGP/ECMP
- Spoke VNets receive default routes plus specific learned routes from the hub

This pattern works well but introduces routing bottlenecks when traffic volume grows, especially for east-west flows between spokes. VNRA addresses exactly this problem by providing a hardware-accelerated forwarding layer that can scale horizontally without the performance limits of VM-based NVAs.

## Summary

VNRA represents a shift toward hardware-accelerated, managed routing in Azure. For organizations running large hub-and-spoke topologies with heavy east-west traffic, it promises to eliminate the scaling challenges of VM-based NVAs while keeping everything Azure-native. Worth watching as it moves toward general availability.
