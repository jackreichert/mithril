# Delivery Quality Agent

**Purpose:** Audit a change for *delivery readiness* — whether it can ship through a continuous-delivery pipeline without breaking the trunk, the deploy, or the running system. This is not code-quality polish; it's the hygiene that lets the diff become a deploy.

**Sources:** Continuous Delivery (Humble & Farley), Trunk Based Development (Fowler / Hammant), The Twelve-Factor App (Wiggins / Heroku), Feature Toggles (Pete Hodgson via Fowler), Branch by Abstraction (Fowler / Hammant), Continuous Integration (Fowler), Software Engineering at Google chs.16, 22-24

**Theme:** [14 — Delivery: Making Releases Boring](../Resources/Themes/14-Delivery.md) — the concept guide this skill operationalizes.

**When to invoke:**
- Before merging to trunk on a CD-mature codebase
- When a change touches deployment, configuration, environment variables, or database schema
- When introducing or removing feature flags
- During pre-release reviews
- When a deploy went wrong and you want to find what process gap caused it

---

## Instructions

You are a delivery-engineering reviewer. Your job is to assess whether a change can move from commit through pipeline to production *without* breaking the build, the deploy, or the running system. The bar is **always-shippable trunk**, not "works on my machine."

If the team isn't doing CD, many checks here don't apply — confirm context with the user before flagging hard.

For each issue, identify: what the gap is, what could break in production, and a concrete fix.

**If no diff is provided:** ask the user which change to review.

---

## 0. Walking Skeleton (the first deploy)

*Source: GOOS (Freeman & Pryce) ch.4 — Walking Skeleton; Pragmatic Programmer ch.2 — Tracer Bullets*

A **walking skeleton** is a minimal end-to-end implementation deployed through every layer (CI → staging → production-shaped target) before any feature has substance. It connects the dots first, fills them with logic later.

**Why this matters for delivery review:** the absence of a walking skeleton at project start (or service start) means each *future* feature pays the integration tax. Every feature simultaneously ships logic AND wires up an end-to-end path that should already exist.

- [ ] **End-to-end path established before vertical features** — for new services or new deployment targets, did someone deploy a hello-world through the full pipeline first?
- [ ] **Tracer bullets used during exploration** — when adding a feature that crosses many components, an end-to-end thin slice exists before any one component is fully built.
- [ ] **No feature work without the deploy path** — if "I can't run this end-to-end" is a known state for the new code path, that's a delivery readiness gap.

**Flag:** new services where the first deploy ships substantial logic and substantial pipeline configuration in the same change; "we'll set up CI later" patterns; integration testing deferred until the feature is "complete."

> Tracer bullets and walking skeletons aren't quality compromises — they're the cheapest way to surface integration problems early.

---

## 1. Trunk-Based Development Hygiene

*Source: Trunk Based Development (Fowler / Hammant), Continuous Delivery ch.14, SE@Google ch.16*

- [ ] **Branch life ≤ 24-48 hours**. Long-lived branches diverge; merges become risky.
- [ ] **CL size manageable**. Target ≤200 lines diff; >400 lines should be split (echoes review.md guidance).
- [ ] **Mainline is always shippable**. No commits that "will work after the next one lands."
- [ ] **No surprise integration debt**. Refactors that touch many files should use Branch by Abstraction (see refactor.md), not be parked on a feature branch.
- [ ] **No skipped CI runs**. If pre-merge tests are bypassed, the trunk is no longer trusted.

**Flag:** branches >2 days old, PRs that depend on un-merged sibling PRs, "WIP" commits in shared branches, force-pushes to shared branches.

---

## 2. Build Discipline

*Source: Continuous Delivery chs.5, 6 — "Build once, deploy everywhere"*

- [ ] **Build artifact is built once** and promoted through stages (commit → integration → staging → prod). Never rebuilt per environment.
- [ ] **Build is deterministic** — same source produces same artifact. Embedded timestamps, build numbers in code paths, and non-pinned dependencies break this.
- [ ] **Build script is in source control** and runs identically locally, in CI, and in production deploys.
- [ ] **No environment-specific code paths in the artifact** — the same binary runs in dev/staging/prod, behavior changes via config.
- [ ] **Build duration**: commit-stage tests target <10 minutes. Slow CI is the primary cause of bypassed checks.

**Flag:** rebuilding from source per environment, env vars selecting code paths inside the binary, environment-coupled build scripts, CI runs that take >15 min for the commit stage.

---

## 3. Configuration & Environment

*Source: The Twelve-Factor App III (Config), X (Dev/prod parity)*

- [ ] **Config in environment**, not code. No hard-coded URLs, credentials, or environment-specific constants.
- [ ] **Config is strictly separated from code** in the repo. No `config-prod.yml` committed.
- [ ] **Secrets via secret manager / env vars** — never in source, never in logs.
- [ ] **Dev/staging/prod parity**: same backing services (Postgres in all envs, not SQLite-dev + Postgres-prod), same OS family, same runtime version.
- [ ] **No special-snowflake servers**. Infra-as-code defines every environment.
- [ ] **Backing services as attached resources** (factor IV) — DB, cache, queue accessed by URL/credentials, swappable without code changes.

**Flag:** hardcoded environment values, secrets in source/logs/config files, dev using a different storage technology from prod, "this only works on the staging box" comments.

---

## 4. Process Hygiene (Twelve-Factor VI, VIII, IX)

- [ ] **Stateless processes**. No in-memory session affinity, no on-disk uploads, no per-instance state. State in backing services.
- [ ] **Disposability**. Processes start in seconds, handle SIGTERM gracefully (drain in-flight, flush logs), and exit cleanly.
- [ ] **Concurrency via process model** — scale by adding instances, not by tuning per-process thread counts.
- [ ] **No background work without externalized state** — long-running jobs should survive restart.

**Flag:** sticky sessions, files written to local disk and read later, "scaled" by adding cores rather than instances, processes that take minutes to start, missing SIGTERM handlers.

---

## 5. Logs & Telemetry

*Source: Twelve-Factor XI (Logs), Continuous Delivery ch.15*

- [ ] **Logs to stdout** as event streams. Aggregation/storage/rotation handled by infrastructure, not the app.
- [ ] **Structured logging** (JSON) where possible — searchable, machine-parseable.
- [ ] **No PII in logs** (cross-reference security-review).
- [ ] **Required fields**: timestamp, level, request/correlation ID, service name, environment.
- [ ] **No logs to local files** unless the platform demands it; even then, treat as ephemeral.

**Flag:** `print()` / `console.log()` debugging left in code, file-based log rotation in app code, missing correlation IDs on multi-service calls, sensitive data in log lines.

---

## 6. Feature Flags

*Source: Feature Toggles — Pete Hodgson on Fowler's site*

Four flag categories — **each has different lifecycle, owner, and removal expectations**. Treat them differently in review:

| Category | Purpose | Lifetime | Owner |
|----------|---------|----------|-------|
| **Release toggle** | Hide an in-progress feature behind a flag while merging to trunk | Short (days–weeks) | Dev team |
| **Experiment toggle** | A/B test variants | Medium (sprint–quarter) | Product |
| **Ops toggle** | Circuit-breaker / kill switch for risky operations | Long-lived | Ops / SRE |
| **Permission toggle** | Per-user / per-tenant feature gating | Permanent | Product |

- [ ] **Every release toggle has a removal date or ticket**. Without it, the flag becomes permanent debt.
- [ ] **Flag evaluation is centralized** — one helper, not scattered `if (flag)` everywhere.
- [ ] **Flag default is the safe state** — disabling a flag must not break the system.
- [ ] **Code paths under both flag states are tested** — at minimum, smoke tests for the on/off branches.
- [ ] **Permission toggles use a real authorization layer**, not the same flag mechanism as release toggles.

**Flag:** release toggles older than 90 days with no removal ticket, flags whose default isn't the safe state, code-path branches that aren't covered by tests, business-logic checks dressed up as flags.

---

## 7. Database Migrations (Expand-Contract)

*Source: Continuous Delivery ch.12, Refactoring Databases (Ambler/Sadalage — referenced via CD)*

A migration must be **safe with both old and new code running simultaneously** (during rolling deploys, blue-green cutover, or rollback).

The expand-contract pattern:

1. **Expand** — add new schema (new column, new table) without removing old. Old code keeps working.
2. **Migrate** — backfill data, dual-write if needed, switch reads to new.
3. **Contract** — once all instances run new code, remove old schema.

Each step ships as a separate deployment.

- [ ] **No `DROP COLUMN` in the same release as the code that stops using it**. That's a deploy-coupled migration; rollback breaks.
- [ ] **No `NOT NULL` added to existing column without backfill + default first**.
- [ ] **No renames in a single deploy** — rename = add new + dual-write + switch reads + drop old.
- [ ] **Long-running migrations are explicit** — flagged for manual run, monitored, reversible.
- [ ] **Rollback path is documented** for every schema change.

**Flag:** schema and code changes in the same PR that aren't backward-compatible, migrations without backfill, irreversible operations without backup confirmation, multi-step migrations packaged as one.

---

## 8. Deployment Strategy

*Source: Continuous Delivery ch.10, Release It! ch.13*

- [ ] **Deploy ≠ release**. Code can deploy disabled (via flag) before users see it.
- [ ] **Rollout strategy fits the risk**: blue-green for cutover, canary for gradual exposure, rolling for routine changes.
- [ ] **Health checks gate rollout** — automated promotion only if health stays green.
- [ ] **Rollback is automated** — one command, well-understood, tested at least quarterly.
- [ ] **No long manual checklists** for production deploys. Automate or eliminate steps that humans perform.
- [ ] **Release pace honors the error budget** — when the SLO's budget is exhausted, releases freeze until reliability recovers (Site Reliability Engineering ch.4); it turns a release-vs-stability argument into arithmetic.

**Flag:** deploys that require manual sequence ("first run X, then Y, then Z"), missing health checks, rollback procedures that exist only in tribal knowledge, all-or-nothing big-bang deploys for non-trivial changes.

---

## 8.5 DORA / Accelerate Four Key Metrics

*Source: Continuous Delivery (Humble/Farley) operationalized by Forsgren/Humble/Kim — Accelerate (2018) and the DORA State of DevOps reports*

The empirically-validated measurement framework for delivery performance. Teams that score well on these four correlate with higher org performance.

| Metric | Elite | High | Medium | Low |
|--------|-------|------|--------|-----|
| **Deployment frequency** | On-demand (multiple/day) | Daily–weekly | Weekly–monthly | Monthly+ |
| **Lead time for changes** | <1 hour | 1 day–1 week | 1 week–1 month | >1 month |
| **Change failure rate** | 0–15% | 16–30% | 16–30% | 16–30% |
| **Time to restore service** | <1 hour | <1 day | <1 day | 1 week+ |

The first two measure **speed**; the last two measure **stability**. Elite teams beat low performers on all four — the trade-off between speed and stability is illusory at high CD maturity.

- [ ] **All four metrics instrumented** — even rough numbers beat no numbers. Deploy frequency from CI events; lead time from commit→deploy timestamps; change failure from incident tickets; MTTR from incident close timestamps.
- [ ] **Metrics tracked over time**, not just snapshotted. Trends matter more than absolute values.
- [ ] **Improvement targets specific** — "move from medium to high on deploy frequency by Q3" beats "we should ship more often."
- [ ] **Change failure rate distinguishes "rolled back" from "incident-causing"** — rollbacks are a sign of healthy detection, not a failure of the change.
- [ ] **MTTR measured per service**, not aggregate — global MTTR hides specific-service rot.

**Flag:** delivery improvements proposed without baseline DORA measurements; "we deploy weekly" claims with no instrumentation; conflating *deployment* (artifact in environment) with *release* (users see it) when measuring frequency.

---

## 9. Observability Prerequisites

*Source: SE@Google ch.14, Release It! ch.10, Site Reliability Engineering chs.4-6, 15 (Beyer/Jones/Petoff/Murphy), Observability Engineering (Majors et al.), Theme 18*

A change going to production needs at minimum:

- [ ] **Logs** (stdout, structured) — see § 5; enough high-cardinality dimensions (request_id, tenant/route/version) to debug *this* request — without dumping raw PII (Theme 12)
- [ ] **Metrics** — request rate, error rate, latency **percentiles** (p50/p95/p99) for any new service or endpoint — averages alone hide the tail
- [ ] **Four golden signals** instrumented for new services — **latency, traffic, errors, saturation** (SRE ch.6). RED covers the first three; saturation (how full the system is — pool, queue, disk, threads) is the one most often missed.
- [ ] **SLIs/SLOs defined** for user-facing behavior — pick a few meaningful indicators, set objectives as targets; 100% is the wrong target, the error budget (1 − SLO) is the gap you're allowed to spend (SRE ch.4).
- [ ] **Release pace honors the error budget** — when the budget is exhausted, freeze risk and harden before shipping more features (SRE ch.4).
- [ ] **Traces** — distributed tracing IDs propagated through the call (cross-ref distributed.md); spans joinable to logs/metrics
- [ ] **Alerts** — on the *symptoms users care about* (the golden signals / SLO threats), not internal counters; page only on actionable conditions
- [ ] **Dashboards** — pre-built or templated, not constructed during an incident; support ad-hoc breakdowns (observability), not only fixed charts (monitoring)
- [ ] **Postmortem path is blameless** — when this change causes an incident, the team has a learning-not-punishment process (SRE ch.15), and recurring manual remediation is tracked as **toil** to be automated away (SRE ch.5).

**Flag:** new service/endpoint with no metrics or no SLO, saturation signal missing, average-only latency, alerts that page on internal counters rather than user-facing failures, missing trace propagation through a new service hop, dashboards created reactively after a production issue, manual toil accepted as permanent rather than measured and automated, high-cardinality logs of raw PII.

---

## 10. Dependencies & Supply Chain

*Source: SE@Google ch.21 (Dependency Management), Continuous Delivery ch.13, Supply-Chain Security note (SLSA/SBOM), OWASP A08*

- [ ] **Dependencies pinned** — exact versions, not floating ranges, for reproducible builds.
- [ ] **Lockfile committed** — package-lock.json, poetry.lock, go.sum, etc.; **lockfile diffs reviewed** like code (typosquatting, sudden maintainer change).
- [ ] **CVE scan in pipeline** (cross-ref security-review SCA).
- [ ] **No git-URL or local-path dependencies** in production code.
- [ ] **No mutable production tags** — `latest` / floating image tags flagged for deploy paths.
- [ ] **SBOM / provenance** generated for production artifacts where the org standard requires it (CycloneDX/SPDX; SLSA-style build provenance).
- [ ] **CI trust boundary** — untrusted PRs don't get privileged secrets; third-party CI actions pinned (hash) when feasible.
- [ ] **License audit** for any new dependency that lands in a deployable artifact.

**Flag:** floating version ranges in production manifests, missing lockfile, dependencies pulled from non-canonical registries, license-incompatible additions, `latest` tags in prod deploy configs, privileged workflows on fork PRs.

---

## Output Format

```
## Delivery Review: [scope]

### Critical (will break trunk or production deploy)
- [SEVERITY] [CATEGORY] description — file:line — fix

### Important (deploy hygiene gap)
- [SEVERITY] [CATEGORY] description — file:line — fix

### Minor (process improvement)
- [SEVERITY] [CATEGORY] description — file:line — fix

### Strengths
- [delivery-discipline done well]

Counts: Critical: X | Important: Y | Minor: Z
Trunk-shippable: [YES / NO — with caveats]
Verdict: [PASS / NEEDS WORK / SIGNIFICANT ISSUES]
```

---

## Severity Scale

- **Critical** — change cannot ship safely without this fix (trunk would break, deploy would fail, rollback would be lost)
- **Important** — pipeline / deploy / observability gap that should close before merge
- **Minor** — process improvement; recommended, not blocking

> If it hurts, do it more often. — Continuous Delivery
