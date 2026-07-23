# 12 — Security: Thinking Like an Attacker

> **Tier 4 · Verification.** The adversarial lens: every input is hostile until proven otherwise, design flaws outrank implementation bugs, and the supply chain and the logs are part of the attack surface. **Skill:** [`skills/security-review.md`](../../skills/security-review.md) · agent `quality-security-review` (taint tracing: `quality-flow`).

## The idea in one paragraph

Security review inverts the normal reviewer's question from "does this work?" to "how do I make this misbehave?" — every finding is an *exploit scenario*, not a style objection. The OWASP Top 10 is the field's consensus risk map, and its ordering teaches the priorities: **broken access control** is #1 because authentication (who are you) without per-object authorization (may *you* touch *this*?) is the most common real-world hole (the classic IDOR: change the ID in the URL, read someone else's data); injection — SQL, command, XSS — remains the evergreen "data became code" family, answered structurally by parameterization, never by escaping heroics; and cryptographic failures are usually *choices* (home-rolled crypto, MD5, secrets in code) rather than exotic breaks. The 2021 revision's deepest addition is **A04 Insecure Design**: a security bug you can patch, but an insecure *design* — no trust boundaries drawn, no abuse cases considered, security by obscurity — has to be re-architected, so threat modeling belongs in review, not incident response. The perimeter has also widened twice: **A08** makes the build itself attack surface (unpinned dependencies, unverified artifacts, a writable CI pipeline), and **A09** recognizes that undetected breaches are *unanswerable* ones — if auth events and sensitive operations aren't logged tamper-evidently, the attacker writes history. ASVS turns all of it into leveled, checkable verification requirements; tools (SAST, SCA, secrets scanners) are force multipliers whose *absence must be declared*, because an unstated coverage gap is itself a vulnerability.

## The arc (how the ideas build)

- **The posture: adversarial, scenario-based** — findings state attacker capability, path, and impact ("user A fetches user B's orders by changing the path param"), because an exploit scenario is falsifiable and prioritizable while "this looks unsafe" is neither.
- **Access control first** (A01) — authenticate *who*, then authorize *this actor, this object, this action* on every request, server-side, deny-by-default. IDOR is the canonical review catch: any handler that loads a resource by client-supplied ID and skips the ownership check.
- **Injection: keep data data** (A03) — parameterized queries, prepared statements, contextual output encoding; flag any string-built SQL/command/HTML with tainted input regardless of current exploitability (`quality-flow` traces source→sink to prove reachability).
- **Crypto is a set of choices** (A02) — approved algorithms, real key management, TLS in transit, no secrets in source or logs; findings name the wrong choice and the sanctioned replacement (bcrypt/argon2, not MD5; env/secret store, not the repo — the 12-Factor config rule is a security control here).
- **Design flaws outrank bugs** (A04) — draw the trust boundaries in review: where does untrusted data enter, which components trust which, what's the abuse case for this feature? Defense in depth over single points of enforcement; security-by-obscurity claims are findings by definition.
- **The supply chain is code you run** (A06 + A08) — vulnerable/outdated components, unpinned versions, missing lockfiles, unverified artifacts, and CI/CD steps that fetch-and-execute over trust boundaries. The dependency diff is part of the security diff.
- **Detection is a requirement** (A09) — log authentication events, access-control failures, and sensitive operations; protect log integrity; route alerts somewhere a human answers. A breach you can't see or reconstruct is the worst-case outcome of "we'll add logging later."
- **Verify at depth with ASVS; multiply with tools** — ASVS's control families (authn, session, access control, validation, crypto, config, logging) turn the Top 10's risks into per-control checklists at three assurance levels. SAST/SCA/secrets/IaC scanners run when available — and the review *states which didn't*, keeping the coverage profile honest (the skill's tool stance: recommended, not required; absence never silent).

## Key concepts & frameworks

- **Exploit-scenario findings** — capability + path + impact; severity via the normalization table, not adjectives.
- **AuthN ≠ AuthZ; deny by default; server-side always** — the A01 triad behind most real breaches.
- **Taint: source → sink** — the unifying model for injection, SSRF, and path traversal (owned by `quality-flow` at Phase 2).
- **Trust boundaries & abuse cases** (A04) — threat modeling as a review activity, not a workshop artifact.
- **Defense in depth** — no single check between the attacker and the crown jewels.
- **Supply-chain hygiene** (A08) — pinned deps, lockfiles reviewed, artifact integrity, least-privilege CI.
- **Security logging** (A09) — auth events, sensitive ops, integrity, retention, alert routing.
- **ASVS levels** — verification depth scaled to the application's risk.

## The sources

- ★ [**OWASP Top 10 (2021)**](../Standards/01-OWASP-Top-10.md) — the risk map and its ordering.
- ★ [**OWASP ASVS**](../Standards/02-OWASP-ASVS.md) — the leveled verification-requirement spine (with the CWE catalog as the weakness vocabulary beneath both).
- [**The Twelve-Factor App**](../Standards/03-The-Twelve-Factor-App.md) — config in the environment: the secrets-handling control.
- [**Release It!** — Nygard](../Books/Domain-Systems-Design/13-Release-It.md) — unbounded inputs and resource exhaustion as availability attacks (stability meets security).
- [**NASA's Power of 10**](../Standards/04-NASA-Power-of-10.md) — the safety-critical cousin: bounded loops, checked returns — context for how constrained code eliminates whole vulnerability classes.

## What the skill encodes (operational checklist)

- [ ] Every resource access traced for the ownership/authorization check; IDOR is the first question, not the last.
- [ ] Tainted input paths traced to sinks (query, command, HTML, file path, URL); string-built sinks flagged regardless of current reachability.
- [ ] Secrets: none in code, logs, or error messages; config from environment; wrong crypto named with its sanctioned replacement.
- [ ] New features get the two design questions: where are the trust boundaries, and what's the abuse case?
- [ ] Dependency changes reviewed: pinned, lockfile diffed, advisories checked (SCA when available).
- [ ] Auth events and sensitive operations logged; log-injection and log-secrecy both checked.
- [ ] Tool coverage stated explicitly — which SAST/SCA/secrets scanners ran, which didn't, and what that leaves unverified.
- [ ] Findings ship as exploit scenarios with severity normalized to the orchestrator's scale.

## Connects to

[05 — Architecture](05-Architecture-Dependencies-and-Boundaries.md) (trust boundaries are boundaries; bulkheads limit blast radius) · [14 — Delivery](14-Delivery.md) (the pipeline is attack surface — A08 lives there) · [15 — Distributed Systems](15-Distributed-Systems.md) (every network hop is a trust decision) · [13 — Gates & Metrics](13-Gates-and-Metrics.md) (the scanners as enforceable floor).
