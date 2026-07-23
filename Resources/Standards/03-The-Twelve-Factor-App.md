---
title: The Twelve-Factor App
authors: Adam Wiggins (Heroku)
url: 12factor.net
category: Standard — Methodology
focus: SaaS application methodology
---

# The Twelve-Factor App — Heroku (2011)

A methodology for building modern, scalable, maintainable web applications. Originally written from Heroku's experience operating thousands of apps. Now considered baseline for cloud-native services.

## The twelve factors

### I. Codebase
**One codebase tracked in revision control, many deploys.** A single repo per app. Multiple deploys (prod, staging, dev) all build from the same code.

### II. Dependencies
**Explicitly declare and isolate dependencies.** Use language package manifests. Don't rely on system-wide packages. Bundle/freeze versions.

### III. Config
**Store config in the environment.** Config that varies per deploy → environment variables. Never in code. Never in committed files.

### IV. Backing services
**Treat backing services as attached resources.** DBs, queues, caches accessed via URL/credentials. Swappable without code changes (local Postgres ↔ RDS).

### V. Build, release, run
**Strictly separate build and run stages.** Build = code → executable. Release = build + config. Run = execute. Releases are immutable + versioned.

### VI. Processes
**Execute the app as one or more stateless processes.** Sticky sessions, in-memory caches, on-disk uploads — all anti-patterns. Push state to backing services.

### VII. Port binding
**Export services via port binding.** App is self-contained: binds a port, serves HTTP. No external app server required.

### VIII. Concurrency
**Scale out via the process model.** Fork more instances; let the OS handle it. Process types in the Procfile (web, worker).

### IX. Disposability
**Maximize robustness with fast startup and graceful shutdown.** Processes start in seconds, handle SIGTERM, finish in-flight work, then exit.

### X. Dev/prod parity
**Keep development, staging, and production as similar as possible.** Same backing services, same runtime, same OS. Dev SQLite + Prod Oracle = bug source.

### XI. Logs
**Treat logs as event streams.** Write to stdout. Aggregation/storage/rotation handled by infrastructure, not the app.

### XII. Admin processes
**Run admin/management tasks as one-off processes.** DB migrations, maintenance tasks — same code, same deps, same release; just a different invocation.

## What 12-Factor enables
- Containerization (Docker maps cleanly).
- Horizontal scaling (factor VIII).
- Cloud portability (factor IV).
- Zero-downtime deploys (factor V + VI).
- Standard observability (factor XI).

## Modern extensions
- **API-first** design.
- **Telemetry** (logs + metrics + traces).
- **Authentication and authorization** as first-class concerns.
Some draft a "15-Factor" or "Beyond the Twelve-Factor App" (Pivotal) covering these.

## Pairs with
- **Continuous Delivery** (Humble & Farley).
- *Release It!* — operational concerns the 12 factors complement.
