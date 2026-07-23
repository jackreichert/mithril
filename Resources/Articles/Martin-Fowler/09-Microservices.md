---
title: Microservices
authors: Martin Fowler, James Lewis
url: martinfowler.com/articles/microservices.html
category: Article — Martin Fowler
focus: Service boundaries, independent deployability
---

# Microservices — Fowler & Lewis (2014)

The article that named and synthesized the architectural style. Not the originator (Netflix, Amazon, ThoughtWorks were already doing it) but the canonical *definition*.

## Defining characteristics

1. **Componentization via Services** — components are independently deployable services, not libraries.
2. **Organized Around Business Capabilities** — Conway's Law inverted: shape teams around business capabilities so the architecture follows.
3. **Products Not Projects** — long-running ownership; "you build it, you run it."
4. **Smart Endpoints, Dumb Pipes** — logic in the services, not in the bus (anti-ESB).
5. **Decentralized Governance** — pick the right tool per service.
6. **Decentralized Data Management** — each service owns its data; eventual consistency between services.
7. **Infrastructure Automation** — CI/CD as a prerequisite.
8. **Design for Failure** — every service must assume any other can fail (cf. Release It! patterns).
9. **Evolutionary Design** — services replaceable, not eternal.

## What microservices give you
- Independent scaling per service.
- Independent deployment.
- Per-service language and persistence freedom.
- Fault isolation (when boundaries are right).

## The trade-off Fowler emphasizes
> "You shouldn't start with microservices."

A monolith with clean modular boundaries is *easier* until the team and codebase grow past the threshold where coordination costs > distribution costs. Premature microservices = distributed monolith = worst of both worlds.

## Microservice prerequisites (the "monolith first" rule)
- Mature CI/CD.
- Observability — logs, metrics, distributed tracing.
- DevOps culture.
- Service-discovery and config management.
- Strong boundaries within the existing monolith.

## Related Fowler entries
- **MonolithFirst** — "consider a monolith first" advice.
- **MicroservicePremium** — the cost of distribution.
- **MicroservicePrerequisites**.
- **DistributedMonolith** — the failure mode to avoid.

## Connection to other resources
- **DDIA** for the data-management challenges.
- **Release It!** for the resilience patterns each service needs.
- **Continuous Delivery** for the deployment substrate.
