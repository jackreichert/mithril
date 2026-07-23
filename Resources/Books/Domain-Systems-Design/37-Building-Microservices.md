---
title: Building Microservices
author: Sam Newman
year: 2021
category: Domain-Systems-Design
focus: service decomposition, information hiding, communication styles, deployment, testing, resilience, observability for microservices
---

# Building Microservices — Sam Newman (2021, 2nd ed.)

The definitive practitioner's guide to designing, deploying, and operating fine-grained services. Feeds the **quality-distributed** agent: it is the book behind the microservice boundary, coupling, and communication concerns that skill reviews — the practical complement to Fowler's *Microservices* article and the Waldo *A Note on Distributed Computing* paper already in the canon. Where Waldo warns that remote calls are not local calls, Newman shows how to model the boundaries, choose the communication style, and survive the partial failure that follows.

## Per-chapter summary

### Ch 1 — What Are Microservices?
Independently deployable services modeled around a business domain, owning their own data. The whole point is independent deployability; hold that as the litmus test for every later decision. Sets up the core trade-offs and warns microservices are not a free lunch.

### Ch 2 — How to Model Microservices
Find boundaries with information hiding, loose coupling, and high cohesion; reach for domain-driven design's bounded contexts. Distinguishes the coupling types — domain, pass-through, common, content (worst) — and pushes structural and temporal decoupling. A good service hides a lot behind a stable, narrow interface.

### Ch 3 — Splitting the Monolith
Treat decomposition as incremental migration, not a big-bang rewrite — extract one seam at a time and keep shipping. Patterns: strangler fig, branch by abstraction, parallel run, decorating collaborator. The data is the hard part: untangle shared databases deliberately before splitting the code.

### Ch 4 — Microservice Communication Styles
Frames the axes: synchronous-blocking vs. asynchronous-nonblocking, and request-response vs. event-driven collaboration. Each style trades coupling for complexity; no single style is universally right. Default to whichever lowers coupling for the interaction at hand.

### Ch 5 — Implementing Microservice Communication
Concrete technology choices — RPC, REST, GraphQL, message brokers — and the ergonomics of each. Favor explicit schemas, tolerant readers, and backward-compatible changes so you can deploy services independently. Avoid breaking changes; version only as a last resort.

### Ch 6 — Workflow
Multi-service business processes: distributed transactions (two-phase commit) versus sagas. Avoid distributed transactions — they reintroduce the coupling and locking microservices exist to escape. Prefer orchestrated or choreographed sagas with explicit compensating actions for rollback.

### Ch 7 — Build
Map each microservice to its own source repository and CI pipeline so builds and releases stay independent. One-service-per-build keeps the blast radius small; monorepos and shared libraries quietly recouple teams. Build the artifact once and promote it through environments.

### Ch 8 — Deployment
Surveys deployment options — physical hosts, VMs, containers, Kubernetes, FaaS — against principles like isolation, automation, and fast desired-state management. Co-locating multiple services per host destroys independent deployability. Kubernetes earns its complexity only at scale; don't adopt it reflexively.

### Ch 9 — Testing
The test pyramid still holds, but end-to-end tests across services are slow, flaky, and own a confused failure story — minimize them. Use consumer-driven contracts (e.g., Pact) to verify integration without a full environment. Complement with in-production testing: smoke tests, canaries, synthetic transactions.

### Ch 10 — From Monitoring to Observability
Shift from predefined dashboards to asking arbitrary questions of a live system you didn't anticipate. The three pillars — logs, metrics, distributed traces — plus correlation IDs to follow a request across services. Build for the unknown-unknowns; static monitoring breaks down as service count grows.

### Ch 11 — Security
More services means a larger attack surface but more chances to defend in depth. Apply the five functions (protect, detect, respond, recover, identify), least privilege, and defense in depth. Authenticate and authorize service-to-service calls (JWT, mTLS); never trust the network.

### Ch 12 — Resiliency
Resiliency is more than retries — it spans robustness, rebound, graceful extensibility, and sustained adaptability. Apply stability patterns: timeouts on every call, circuit breakers, bulkheads, isolation. A slow dependency is worse than a dead one; bound every wait and degrade gracefully under partial failure.

### Ch 13 — Scaling
Four axes: vertical (bigger box), horizontal duplication (more copies), data partitioning (sharding), and functional decomposition. Pick the axis that targets your actual bottleneck rather than scaling everything. Scale only what needs it, and measure before and after.

### Ch 14 — User Interfaces
The UI is a first-class consumer of services, not an afterthought bolted on. Patterns: API composition, backend-for-frontend (BFF), and micro-frontends to let teams own a vertical slice end to end. Avoid a single shared API gateway becoming a coupling chokepoint.

### Ch 15 — Organizational Structures
Conway's Law: system structure mirrors the communication structure of the org that builds it. Favor stream-aligned, loosely coupled teams that own services end to end, supported by platform and enabling teams. Shared service ownership diffuses responsibility; strong ownership scales.

### Ch 16 — The Evolutionary Architect
Architects are town planners and gardeners, not master builders — guide evolution, don't dictate it. Define the few cross-cutting principles and practices (the "paved road"), then give teams autonomy within them. Govern by exemplars and tailored service templates, and track technical-debt exceptions explicitly.

## Critiques worth knowing
- **Microservices are a means, not a goal.** Newman repeatedly warns against adopting them for resume-driven or hype reasons; a well-modularized monolith is often the right answer, and the book's own conclusion is "you probably shouldn't, yet."
- **The hard part is data and the org, not the code.** Splitting databases (Ch 3) and aligning teams (Ch 15) dominate real migrations; the service code is the easy 20%.
- **Distributed complexity is permanent.** Every benefit (independent deployability, scaling) is paid for in operational complexity, network failure modes, and eventual consistency — costs the book is honest about but that teams routinely underestimate.
- **2nd-edition shift:** more emphasis on incremental migration patterns, sagas over distributed transactions, observability over monitoring, and Conway's Law than the 2015 first edition — reflecting hard-won industry experience, not just theory.
