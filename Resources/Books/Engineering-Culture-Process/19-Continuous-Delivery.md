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

### Ch 1 — The Problem of Delivering Software
Painful releases are a symptom of a weak delivery process, not an unavoidable fact of software development. Manual deployments create flakiness, anxiety, and downtime because they depend on inconsistent human execution. The chapter's principles are to keep software production-ready, automate and version-control everything, shift quality work left, and define "done" as released.

### Ch 2 — Configuration Management
Configuration management places source code, build definitions, environment definitions, and application configuration under version control. No artifact needed to reproduce or deploy the system should remain unversioned. Branches should also be short-lived so configuration and code do not drift into incompatible states.

### Ch 3 — Continuous Integration
Continuous integration requires developers to merge into the mainline at least daily. Every commit should trigger fast tests that expose integration failures quickly. A broken build must be fixed or reverted immediately because CI is a shared practice, not merely a tool that runs in the background.

### Ch 4 — Implementing a Testing Strategy
Brian Marick's test quadrant divides testing into unit or component tests, functional or story tests, exploratory or usability tests, and performance or security tests. Each quadrant answers a different kind of question about the product. A complete testing strategy needs evidence from all four rather than treating one category as sufficient.

### Part II — The Deployment Pipeline ⭐

### Ch 5 — Anatomy of the Deployment Pipeline
The deployment pipeline moves a change through a commit stage, automated acceptance tests, manual testing, and release. Each stage gates promotion so weak candidates fail before reaching more expensive or risky checks. The rule "build once, deploy everywhere" means the exact same artifact advances through every environment.

### Ch 6 — Build and Deployment Scripting
Build and deployment scripts are first-class production assets rather than disposable conveniences. The same script should work locally, in continuous integration, and in production. Reusing one automated path reduces hidden environmental differences and makes deployments repeatable.

### Ch 7 — The Commit Stage
The commit stage compiles the code, runs unit tests and static analysis, creates the deployable artifact, and performs a basic smoke test. It is the pipeline's first broad gate and should reject obvious defects quickly. The target runtime is under ten minutes so developers can respond while the change is still fresh.

### Ch 8 — Automated Acceptance Testing
Automated acceptance tests exercise a fully deployed system against expected business behavior. Because these tests are slower than commit-stage checks, they run only after a candidate passes the faster gate. Behavior-driven development frameworks can express the scenarios, but teams must still solve difficult test-isolation problems.

### Ch 9 — Testing Non-Functional Requirements
Correct features are not enough if the system fails under load or exposes security weaknesses. Capacity, performance, and security checks should therefore become automated pipeline stages. Running them repeatedly turns non-functional requirements into measurable release criteria instead of late surprises.

### Ch 10 — Deploying and Releasing Applications
Deployment places a version in an environment, while release makes its behavior available to users. Feature flags decouple those events so exposure can be controlled independently of installation. Rollback procedures, blue-green deployments, and canary releases provide different ways to limit and recover from production risk.

### Part III — The Delivery Ecosystem

### Ch 11 — Managing Infrastructure and Environments
Infrastructure as Code records environment definitions in a form that can be reviewed and reproduced. Automated provisioning creates environments consistently without relying on manual server setup. This approach prevents special-snowflake servers whose undocumented differences make releases unpredictable.

### Ch 12 — Managing Data
Database schema migrations should be versioned and executed as code. Expand-contract changes preserve backward compatibility while old and new application versions overlap during deployment. Reliable test-data management gives automated checks realistic inputs without depending on uncontrolled production state.

### Ch 13 — Managing Components and Dependencies
Componentization divides a system into parts with explicit responsibilities and contracts. Dependency graphs and semantic versioning help teams reason about how changes propagate between those parts. Dependency injection keeps component wiring replaceable, although the resulting ecosystem still requires active compatibility management.

### Ch 14 — Advanced Version Control
Trunk-based development is preferred to GitFlow because it keeps integration frequent and visible. Branch by abstraction allows a large change to proceed behind a stable interface while both implementations coexist. Long-lived branches are an antipattern because they accumulate merge debt and postpone integration surprises.

### Ch 15 — Managing Continuous Delivery
Continuous delivery adoption can be assessed with maturity models that show which capabilities an organization has made routine. Risk management should be built into the delivery process rather than added as a final approval ritual. Compliance requirements can likewise become automated controls that produce repeatable evidence on every change.

## Key sayings / vocabulary
- **Deployment Pipeline** — staged automated path from commit to production.
- **Build once, deploy everywhere.**
- **If it hurts, do it more often.**
- **Configuration as code, infrastructure as code.**
- **Branch by Abstraction** for safe large refactors.

## Pairs with
- **Accelerate** (Forsgren, Humble, Kim) — the empirical follow-up showing CD practices correlate with org performance.
- **The DevOps Handbook** — operationalizes the same ideas.
