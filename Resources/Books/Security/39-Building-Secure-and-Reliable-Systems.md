---
title: Building Secure and Reliable Systems
author: Heather Adkins, Betsy Beyer, Paul Blankinship, Piotr Lewandowski, Ana Oprea, Adam Stubblefield
year: 2020
category: Security
focus: security + reliability as design-time properties — least privilege, design for understandability, defense in depth, resilience, and recovery
---

# Building Secure and Reliable Systems — Adkins, Beyer, Blankinship, Lewandowski, Oprea, Stubblefield (2020)

Google/O'Reilly's companion to the SRE books: treats security and reliability not as features bolted on at the end but as intertwined properties designed in from the start. Feeds the **quality-security-review** and **quality-delivery** agents. Where OWASP gives a reactive checklist of known vulnerability classes, this book supplies the proactive design discipline that prevents whole categories before they exist — least privilege, understandability, defense in depth, and graceful recovery. Backs Article V (least privilege everywhere); free online at sre.google/books.

## Per-part summary

### Part I — Introductory Material
Establishes the thesis: a system isn't truly reliable unless it's secure, and the two goals trade off and reinforce each other across the whole lifecycle (Ch 1). Reliability defends against benign failures and acts of nature; security defends against an intelligent adversary who adapts. Both demand the same investment in design, testing, and operations. Understand your adversaries — script kiddies, hacktivists, criminals, insiders, nation-states — and model their motivations and capabilities rather than chasing generic "hackers" (Ch 2). Confidentiality, integrity, and availability are the shared currency of both disciplines.

### Part II — Designing Systems
The design core. **Least privilege** (Ch 5): grant the minimum access needed, default to denying, use zero-trust networking, require multi-party authorization for risky actions, and audit everything — small, scoped credentials limit blast radius. **Design for understandability** (Ch 6): a system you can't reason about can't be secured; invariants, clear trust boundaries, and minimal-API "safe proxies" (the Ch 3 case study) make security analyzable. **Design for a changing landscape** (Ch 7): build for evolution — rotate keys, deprecate gracefully, ship frequent small changes so security fixes deploy fast. **Design for resilience** (Ch 8): defense in depth, controlled degradation, blast-radius containment, and failing safe under attack. **Design for recovery** (Ch 9): assume compromise and design to recover predictably — rollbacks, known-good states, rate-limited automation. Plus DoS mitigation (Ch 10) and explicit design tradeoffs (Ch 4): security/reliability vs. feature velocity, cost, and usability.

### Part III — Implementing Systems
From design to code. **Writing code** (Ch 12): prevent classes of bugs structurally — strong typing, safe-by-construction libraries and frameworks, sanitization at the boundary, integer/memory safety — so individual engineers can't introduce SQLi or XSS. **Testing code** (Ch 13): unit, integration, fuzzing, and static analysis as continuous gates, not one-off audits — fuzz untrusted input paths, treat security tests as first-class. **Deploying code** (Ch 14): build-time integrity, provenance, binary authorization, and a verifiable supply chain so only reviewed, attested artifacts reach production. **Investigating systems** (Ch 15): debuggability and logging designed in so you can answer "what happened" during an incident. Anchored by the publicly-trusted-CA case study (Ch 11).

### Part IV — Maintaining Systems
Operating under stress. **Disaster planning** (Ch 16): risk assessment, defined response strategies, drills, and prepared playbooks before the crisis. **Crisis management** (Ch 17): incident command, clear roles, controlled communication, and decision-making under uncertainty — keep a calm, structured response. **Recovery and aftermath** (Ch 18): restore from known-good states, eradicate attacker persistence, conduct blameless postmortems, and feed lessons back into design. The loop closes: incidents become design inputs.

### Part V — Organization and Culture
Security and reliability are organizational properties, not individual heroics. Define **roles and responsibilities** clearly (Ch 20) so ownership doesn't fall through gaps. Build a **culture of security and reliability** (Ch 21): make it everyone's job, reward people for raising concerns, default to secure-by-design tooling, and balance security against productivity so the safe path is the easy path. The Chrome Security Team case study (Ch 19) shows the culture in practice.

## How it maps to the Constitution
- **Article V (Security & Secrets)** — least privilege everywhere, zero-trust, validated input at the boundary, no committed secrets; this book is the design-time backbone.
- **Article III (Design & Architecture)** — design for understandability and narrow trust boundaries echo deep modules / narrow interfaces and dependencies-point-inward.
- **Article VI (Delivery)** — deploy-code integrity, binary authorization, and provenance back expand-contract, shippable-increment, and observability rules.
- **Article II (Code)** — safe-by-construction libraries and structural bug-prevention reinforce "fail fast, fail loud" and validated input.

## Critiques worth knowing
- **Heavily Google-shaped.** Reflects Google-scale infrastructure (BeyondCorp/zero-trust, internal CAs, massive fleets); smaller teams must translate principles, not copy practices wholesale.
- **Long and uneven.** 21 chapters with repetition across parts; better as a reference to pull from than a cover-to-cover read.
- **Aspirational tooling.** Many controls (binary authorization, custom safe frameworks) assume platform investment most orgs lack — the principles transfer, the implementations often don't.
- **Light on threat modeling mechanics.** Strong on philosophy and adversary types; thinner on concrete step-by-step threat-modeling process than dedicated security texts.
