---
title: Observability Engineering
authors: Charity Majors, Liz Fong-Jones, George Miranda
year: 2022
category: Performance-Reliability
focus: High-cardinality events, debugging production, structured telemetry, sampling, the three pillars vs. event-first observability
---

# Observability Engineering — Majors, Fong-Jones, Miranda (2022)

The modern statement of **observability as a product capability**: the ability to ask novel questions about production behavior without shipping new instrumentation first. It is the companion to *Site Reliability Engineering*'s golden signals — SRE tells you *what* to measure for reliability; this book tells you *how* telemetry must be shaped so humans can debug unknown-unknowns. Feeds **mithril-delivery** (observability prerequisites) and **mithril-flow** (source→sink diagnosis).

## Core claims

### Observability ≠ monitoring
- **Monitoring** asks known questions (dashboards, alerts on predefined SLOs).
- **Observability** supports *unknown* questions: "why is *this* cohort slow?" requires high-cardinality, high-dimensionality event data, not only pre-aggregated metrics.

### Events first, not "three pillars" as silos
- The popular "metrics + logs + traces" split is useful tooling taxonomy but a poor *mental* model if each pillar is stored without joinable context.
- Prefer **wide structured events** (or rich spans) with enough dimensions (service, route, tenant, version, region, status, latency) that you can break down *after* the fact.
- Trace context (`trace_id` / `span_id`) must propagate across process boundaries — otherwise distributed systems are undebuggable (cross-ref Theme 15 / Waldo).

### Cardinality is a feature (within bounds)
- High-cardinality fields (user id, request id, order id) enable debugging individual journeys.
- Unbounded cardinality without sampling/aggregation strategy blows cost and can leak PII — pair with Theme 12 (no PHI/PII in logs) and deliberate sampling (head vs tail-based).

### Instrumentation is a design decision
- Instrument at user-visible boundaries and critical path hops, not every function.
- Golden signals (latency, traffic, errors, saturation) remain the floor; observability is how you *explain* a golden-signal breach.

### Culture
- On-call must be able to explore production data without filing a ticket for a new dashboard.
- Blameless postmortems need data; without observability, postmortems become narrative guesswork (SRE ch.15).

## What to encode in review

- New endpoints/services ship **structured** logs + metrics + **trace propagation**, not "we can SSH and read a file."
- Alerts attach to **symptoms** (SLO / golden signals), with enough event context to start debugging.
- Diffs that add high-cardinality log fields of raw PII → security finding.
- Diffs that add metrics with **only averages** and no percentiles/saturation → performance/operability finding (Theme 18).
- Fire-and-forget async without correlation ids → flow/distributed finding.

## Honest caveats

- Vendor-neutral principles; implementation details (specific APM products) age quickly — prefer OpenTelemetry concepts over product names.
- Cost of full-fidelity telemetry is real; the book is not a blank check for infinite retention.
- Complements, does not replace, SRE's SLO/error-budget discipline.

## Cross-refs in this library

- Theme [18 — Performance & Operability](../../Themes/18-Performance-and-Operability.md)
- Theme [14 — Delivery](../../Themes/14-Delivery.md)
- [SRE summary](33-Site-Reliability-Engineering.md)
- Skills: `delivery.md` § observability; `distributed.md` tracing; `security-review.md` logging/PII
