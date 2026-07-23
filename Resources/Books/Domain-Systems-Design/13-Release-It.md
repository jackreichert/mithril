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

**Ch 1 — Living in Production**
Production is different from QA. Multi-day uptime, version skew, real users, real data. The shift from "shipping" to "operating."

**Ch 2 — Case Study: The Exception that Grounded an Airline**
A `SQLException` deep in a JDBC connection pool brought down kiosks and airline-wide check-in. Lesson: tightly coupled systems fail far from the original fault.

**Ch 3 — Stabilize Your System**
Stability as a design property. Failure modes propagate; cracks become chasms.

**Ch 4 — Stability Antipatterns**
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

**Ch 5 — Stability Patterns** ⭐
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

**Ch 6 — Case Study: Phenomenal Cosmic Powers, Itty-Bitty Living Space**
A massive marketing push that traffic-engineered the site into oblivion.

**Ch 7 — Foundations**
Networking, DNS, load balancers, TLS — the substrate that supports your code.

**Ch 8 — Processes on Machines**
Container limits, instrumentation, configuration sources, externalizing state.

**Ch 9 — Interconnect**
Service discovery, DNS-based vs. registry-based. Routing concerns.

**Ch 10 — Control Plane**
What's running, where, how it's configured. Without a control plane, ops is wandering in the dark.

**Ch 11 — Security**
OWASP Top 10 in production context: principle of least privilege, secret management, defense in depth.

### Part III — Deliver Your System

**Ch 12 — Case Study: Waiting for None**
A blue-green deployment story.

**Ch 13 — Design for Deployment**
Zero-downtime deploys, canary, rolling, blue-green. Backward-compatible schemas, expand-contract migrations.

### Part IV — Solve Systemic Problems

**Ch 14 — Handling Versions**
Multiple versions running simultaneously is normal, not exceptional.

**Ch 15 — Case Study: Trampled by Your Own Customers**
The "synchronized retry" outage.

**Ch 16 — Adaptation**
Systems must change while running. Plan for change as you would for failure.

**Ch 17 — Chaos Engineering**
Inject faults in production to surface latent failures. Game days. Failure-injection playbooks.

## Why it's deeply integrated into `/quality architecture` + `/quality security`
Stability antipatterns and patterns map directly to the resilience pillar of architecture review.
