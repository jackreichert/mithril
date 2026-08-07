---
title: Release It! Design and Deploy Production-Ready Software (2nd ed.)
author: Michael T. Nygard
year: 2018
category: Domain & Systems Design
focus: Stability patterns, circuit breakers, bulkheads, production-readiness
---

# Release It! (2nd ed.) — Michael T. Nygard (2018)

The book that introduced **Circuit Breaker** and **Bulkhead** to the mainstream. Built around production war-stories — outages narrated in detail before each lesson.

## Per-chapter summary

### Part I — Create Stability

### Ch 1 — Living in Production
Production is different from QA because software faces multi-day uptime, version skew, real users, and real data. These conditions expose interactions and cumulative failures that short test runs rarely reveal. Teams must shift their attention from merely shipping software to operating it as a living system.

### Ch 2 — Case Study: The Exception that Grounded an Airline
A `SQLException` deep in a JDBC connection pool brought down kiosks and airline-wide check-in. The incident shows how a local resource failure can travel through shared dependencies until an entire operation stops. Tightly coupled systems often fail far from the original fault, so designers must trace and contain those propagation paths.

### Ch 3 — Stabilize Your System
Stability is a design property rather than an outcome that testing can add later. Failure modes propagate through dependencies and shared resources when the system lacks containment. Small cracks can therefore become chasms under sustained production load.

### Ch 4 — Stability Antipatterns
Stability antipatterns are recurring design choices that amplify ordinary faults into outages. They often consume a limited resource, propagate pressure to another component, or cause automated behavior to repeat a harmful action. Recognizing these shapes during design and incident review makes the system's failure paths easier to interrupt:
- **Integration Points** are the #1 source of failure. Plan for *every remote call* to fail.
- **Chain Reactions** — failure cascading through similar nodes.
- **Cascading Failures** — failure propagation across system boundaries.
- **Users** — unpredictable load, malicious actors.
- **Blocked Threads** — no timeout, deadlocked pool, infinite retries.
- **Self-Denial Attacks** — your own marketing campaign DDoSes you.
- **Scaling Effects** — linear thinking fails at scale.
- **Unbalanced Capacities** — upstream can flood downstream.
- **Dogpile** — synchronized retries.
- **Force Multiplier** — automated control loops amplify mistakes.
- **Slow Responses** — slower than failing-fast; threads pile up.
- **Unbounded Result Sets** — query that becomes huge in production.

### Ch 5 — Stability Patterns ⭐
Stability patterns constrain failures so the system can preserve useful service during adverse conditions. Some patterns limit time or resource consumption, while others isolate components, regulate demand, or deliberately reject work. They are complementary defenses that should be selected according to the failure modes identified in the system:
- **Timeouts** — every remote call needs one.
- **Circuit Breaker** — open after threshold of failures; half-open to probe.
- **Bulkheads** — isolate resource pools so one failure doesn't sink the ship.
- **Steady State** — clear logs, archive data, prune sessions.
- **Fail Fast** — return error immediately when you'll fail anyway.
- **Let It Crash** — restart over recovery (Erlang/OTP roots).
- **Handshaking** — protocol-level health checks.
- **Test Harnesses** — chaos-style remote-fault injection.
- **Decoupling Middleware** — message queues to absorb load.
- **Shed Load** — drop requests to protect the survivable core.
- **Create Back Pressure** — slow callers when overwhelmed.
- **Governor** — rate-limit dangerous operations.

### Part II — Design for Production

### Ch 6 — Case Study: Phenomenal Cosmic Powers, Itty-Bitty Living Space
A massive marketing push drove more traffic than the site could safely handle. The resulting outage demonstrates that demand generation and technical capacity are parts of the same production system. Operational limits must be understood before a successful campaign turns expected user interest into self-inflicted denial of service.

### Ch 7 — Foundations
Networking, DNS, load balancers, and TLS form the substrate that supports application code. Failures or misconfiguration in this substrate can make healthy processes unreachable or unsafe. Production-ready design therefore requires developers to understand the infrastructure paths every request traverses.

### Ch 8 — Processes on Machines
Application processes run within machine or container limits that shape their actual behavior. Instrumentation and explicit configuration sources make that runtime behavior visible and controllable. Externalizing durable state allows processes to be replaced or restarted without losing the system's essential data.

### Ch 9 — Interconnect
Interconnect concerns determine how one running service locates and reaches another. DNS-based discovery and registry-based discovery offer different consistency, availability, and operational trade-offs. Routing must account for changing instances and partial failure instead of assuming that a configured address remains valid forever.

### Ch 10 — Control Plane
A control plane records what is running, where it is running, and how it is configured. It gives operators a coherent way to inspect and change the desired state of the system. Without a control plane, operations teams are forced to reconstruct reality from scattered machines and incomplete signals.

### Ch 11 — Security
Production security applies principles such as least privilege, secret management, and defense in depth to the deployed system. The OWASP Top 10 provides a practical view of common application risks, but controls must also cover infrastructure and operations. Security has to survive real configuration, access, and failure conditions rather than exist only in source code.

### Part III — Deliver Your System

### Ch 12 — Case Study: Waiting for None
This case study follows a blue-green deployment, in which old and new production environments exist side by side. Traffic can move to the new version only after it is ready, avoiding an outage while servers are updated. Keeping the previous environment available also creates a fast rollback path when validation fails.

### Ch 13 — Design for Deployment
Deployment techniques such as canary, rolling, and blue-green releases reduce the risk of changing a live system. Zero-downtime delivery requires old and new application versions to coexist safely during the transition. Backward-compatible schemas and expand-contract migrations preserve that compatibility until every dependent component has moved forward.

### Part IV — Solve Systemic Problems

### Ch 14 — Handling Versions
Multiple versions running simultaneously are normal in a distributed production system, not an exceptional state. Deployments, retries, queued messages, and independently updated clients all create version overlap. Protocols and data formats must therefore tolerate compatible differences instead of requiring an instantaneous global upgrade.

### Ch 15 — Case Study: Trampled by Your Own Customers
This case study examines an outage caused by synchronized retries. Many clients repeated failed requests at the same time, creating a new load spike before the recovering system could stabilize. Retry policies need backoff, jitter, and limits so clients do not coordinate into another denial-of-service wave.

### Ch 16 — Adaptation
Production systems must change while they continue running. Adaptation includes both planned evolution and automatic responses to changing load or health. Plan for change as deliberately as failure so control loops and operational interventions remain bounded and observable.

### Ch 17 — Chaos Engineering
Chaos engineering injects controlled faults to surface latent failures before an uncontrolled incident does. Game days let teams rehearse detection, response, and recovery against a defined scenario. Failure-injection playbooks must bound the experiment, protect critical service, and state how to stop it when the observed behavior becomes unsafe.

## Why it's deeply integrated into `/mithril architecture` + `/mithril security`
Stability antipatterns and patterns map directly to the resilience pillar of architecture review.
