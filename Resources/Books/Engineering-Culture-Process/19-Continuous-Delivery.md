---
title: Continuous Delivery — Reliable Software Releases through Build, Test, and Deployment Automation
authors: Jez Humble, David Farley
year: 2010
category: Engineering Culture & Process
focus: Deployment pipelines, trunk-based dev, feature flags
---

# Continuous Delivery — Humble & Farley (2010)

The book that defined the **Deployment Pipeline** as the central artifact of modern delivery. Jolt-award winner. Underpins DevOps and DORA metrics research.

## Per-part / per-chapter summary

### Part I — Foundations

**Ch 1 — The Problem of Delivering Software**
Release pain is a symptom, not a fact of life. Manual deploy → flakiness, anxiety, downtime. The "principles": software always production-ready, automate everything, version-control everything, shift left on quality, done = released.

**Ch 2 — Configuration Management**
Source-control source, build, environment, application config. No artifact unversioned. Branches must be short-lived.

**Ch 3 — Continuous Integration**
Mainline integration daily-or-better. Fast tests on every commit. Fix broken builds immediately or revert. CI is a *practice*, not a tool.

**Ch 4 — Implementing a Testing Strategy**
The test quadrant (Brian Marick): Q1 unit/component, Q2 functional/story, Q3 exploratory/usability, Q4 performance/security. All four needed.

### Part II — The Deployment Pipeline ⭐

**Ch 5 — Anatomy of the Deployment Pipeline**
Commit stage → automated acceptance → manual testing → release. Each stage gates promotion. **Build once, deploy everywhere** — the same artifact promotes through stages.

**Ch 6 — Build and Deployment Scripting**
Scripts are first-class. Same script local, in CI, in prod.

**Ch 7 — The Commit Stage**
Compile, unit test, static analysis, build artifact, basic smoke test. Target: under 10 minutes.

**Ch 8 — Automated Acceptance Testing**
Tests against fully deployed system. Slow → run after commit stage. BDD frameworks. Test isolation challenges.

**Ch 9 — Testing Non-Functional Requirements**
Capacity, performance, security testing as automated stages.

**Ch 10 — Deploying and Releasing Applications**
Deploy ≠ release. Decouple via feature flags. Rollback strategies. Blue-green, canary.

### Part III — The Delivery Ecosystem

**Ch 11 — Managing Infrastructure and Environments**
Infrastructure as Code. Environment provisioning automated. No special-snowflake servers.

**Ch 12 — Managing Data**
Schema migrations as code. Backward-compatible deploys (expand-contract). Test-data management.

**Ch 13 — Managing Components and Dependencies**
Componentization, dependency graphs, semantic versioning, dependency injection.

**Ch 14 — Advanced Version Control**
Trunk-based development > GitFlow. Branch by abstraction. Why long-lived branches are an antipattern (merge debt, surprise integration).

**Ch 15 — Managing Continuous Delivery**
Maturity models. Risk management. Compliance as automated controls.

## Key sayings / vocabulary
- **Deployment Pipeline** — staged automated path from commit to production.
- **Build once, deploy everywhere.**
- **If it hurts, do it more often.**
- **Configuration as code, infrastructure as code.**
- **Branch by Abstraction** for safe large refactors.

## Pairs with
- **Accelerate** (Forsgren, Humble, Kim) — the empirical follow-up showing CD practices correlate with org performance.
- **The DevOps Handbook** — operationalizes the same ideas.
