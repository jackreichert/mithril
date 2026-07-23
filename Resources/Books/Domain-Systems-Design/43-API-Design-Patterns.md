---
title: API Design Patterns
author: JJ Geewax
year: 2021
category: Domain-Systems-Design
focus: Resource-oriented APIs, naming, pagination, errors, versioning, partial updates, long-running operations
---

# API Design Patterns — JJ Geewax (2021)

A practical catalog for **published API** design — primarily HTTP/JSON and resource-oriented style (Google AIP lineage). Bridges Hyrum's Law (every observable becomes contract) with day-to-day choices: naming, pagination, error models, versioning, and compatibility. Feeds **quality-architecture** (public contract stability) and **quality-distributed** / **quality-delivery** (expand-contract evolution).

## Core patterns (high-signal for review)

### Resource orientation
- Nouns for resources, standard verbs (list/get/create/update/delete) over bespoke RPC sprawl when the domain is CRUD-shaped.
- Predictable URLs and consistent field naming reduce client bugs more than clever endpoints.

### Pagination
- Prefer **cursor / keyset** pagination over raw OFFSET for large collections (aligns with *SQL Performance Explained*).
- Stable sort order required; document empty-page vs end-of-collection behavior.

### Errors
- Structured error model (code, message, details) — machine-readable codes for clients, human message for operators.
- Don't overload HTTP 200 with error payloads; don't leak stack traces or internal IDs to untrusted clients (Theme 12).

### Versioning & compatibility
- Prefer **additive** change: new optional fields, new endpoints.
- Breaking changes need deprecation windows, dual-run, or explicit major versions — same expand-contract spirit as schema migrations (Theme 14).
- **Tolerant readers** (ignore unknown fields) make evolution safer.

### Partial updates & idempotency
- PATCH / field masks vs full PUT — document which fields are replace vs merge.
- Unsafe methods that clients retry need **idempotency keys** (Theme 15).

### Long-running operations
- Don't block HTTP for multi-minute work; return operation resource + poll/wait pattern.

## What to encode in review

- New public endpoints: consistent naming, pagination strategy, error shape, auth boundary.
- Diffs that rename/remove fields on a published API without deprecation → contract break (Hyrum).
- OFFSET pagination on unbounded tables → performance finding (Theme 18) + API design finding.
- Missing idempotency on client-retried POSTs → distributed/reliability finding.
- Error responses that expose internals → security finding.

## Honest caveats

- Resource-oriented style is not mandatory for every internal RPC; don't force AIP onto a pure event/message API.
- GraphQL / gRPC have parallel patterns (schema evolution, field presence); principles transfer, syntax does not.
- Complements, does not replace, authn/z design (Theme 12) or domain modeling (Theme 06).

## Cross-refs

- Theme [05 — Architecture](../../Themes/05-Architecture-Dependencies-and-Boundaries.md) (boundaries)
- Theme [14 — Delivery](../../Themes/14-Delivery.md) (expand-contract)
- Theme [15 — Distributed](../../Themes/15-Distributed-Systems.md) (idempotency, partial failure)
- Theme [18 — Performance](../../Themes/18-Performance-and-Operability.md) (pagination cost)
- Architecture skill: Hyrum's Law section; distributed skill: API backward compatibility
