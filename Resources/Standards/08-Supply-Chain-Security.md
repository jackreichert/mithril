---
title: Software Supply Chain Security (SLSA, SBOM, signed artifacts)
category: Standards
focus: Provenance, SBOMs, dependency hygiene, CI trust boundaries, signed builds
---

# Software Supply Chain Security — SLSA, SBOM & related practice

A compact standard note for this library: modern delivery is attacked through **dependencies, build systems, and distribution**, not only application code. Complements OWASP A08 (Software and Data Integrity Failures) and ASVS with concrete controls. Feeds **mithril-security-review** (A08 / SCA) and **mithril-delivery** (pipeline trust).

## Core ideas

### SLSA (Supply-chain Levels for Software Artifacts)
- Levels describe *how much* provenance you have (from "no guarantees" to hardened, isolated builds with two-party review).
- Practical floor for most teams: **reproducible, scripted builds in CI**; **provenance** stating what source + build produced an artifact; **no mutable tags** (`latest`) in production pulls.

### SBOM (Software Bill of Materials)
- Machine-readable inventory of what's *in* a release (CycloneDX / SPDX).
- Enables CVE response ("are we affected?") without archaeology.
- Generate at build time; store with the artifact.

### Dependency hygiene
- Pin exact versions; commit lockfiles; review lockfile diffs like code.
- Prefer packages with provenance; beware typosquatting and brand-new maintainers on critical paths.
- SCA in CI (`npm audit`, `pip-audit`, `govulncheck`, Trivy, …) — tools recommended, not required, but absence must be named (same stance as security-review).

### CI/CD as a trust boundary
- Pipeline configs are production code (OWASP A08).
- Secrets least-privilege; untrusted PRs must not run privileged workflows with secret access without isolation.
- Third-party CI actions/plugins are remote code execution — pin by hash where possible.

### Signed artifacts
- Sign container images / packages; verify on deploy.
- Distinguishes "built by us" from "injected in transit."

## What to encode in review

| Signal in the diff | Finding home |
|--------------------|--------------|
| Lockfile churn, floating ranges, `latest` tags | delivery + security A08 |
| New CI workflow with broad `pull_request` secret access | security |
| No SCA in pipeline for a dependency-heavy service | delivery Important (note coverage gap) |
| Production image without SBOM/provenance where org standard requires it | delivery / security |
| git-URL / path dependencies in production artifact | delivery Critical/Important |

## Honest caveats

- Full SLSA L3+ is organizational investment; don't block a PR for not being Google.
- SBOMs without a process to *consume* them (vuln triage) are theater.
- This note is not a substitute for full SLSA/NIST SSDF reading — it is the agent-executable floor.

## Cross-refs

- [OWASP Top 10](01-OWASP-Top-10.md) A08
- [OWASP ASVS](02-OWASP-ASVS.md)
- Theme [12 — Security](../Themes/12-Security-Review.md)
- Theme [14 — Delivery](../Themes/14-Delivery.md)
- Skills: `security-review.md` A08; `delivery.md` dependencies
