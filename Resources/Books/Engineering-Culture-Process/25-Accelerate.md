---
title: Accelerate — The Science of Lean Software and DevOps
authors: Nicole Forsgren, Jez Humble, Gene Kim
year: 2018
category: Engineering Culture & Process
focus: DORA empirics — four key metrics, capabilities that drive elite delivery performance
---

# Accelerate — Forsgren, Humble & Kim (2018)

A research-backed sequel to *Continuous Delivery*. Where Humble & Farley's earlier book argued *what* to do, Accelerate provides the empirical evidence for *what works* — drawn from the DORA (DevOps Research and Assessment) State of DevOps surveys (2014–2017+).

## Part I — What the research shows

Built around the **Four Key Metrics** (the DORA "Four Keys"):

1. **Deployment frequency** — how often code reaches production
2. **Lead time for changes** — commit to production duration
3. **Change failure rate** — % of deploys causing incidents requiring remediation
4. **Time to restore service** (MTTR) — how long to recover from a production incident

Two measure **speed** (1–2), two measure **stability** (3–4). The book's central empirical finding: *elite teams beat low performers on all four simultaneously*. The intuition that speed trades off against stability is wrong; the trade-off is an artifact of low-maturity practices.

### The performance tiers

| Tier | Deploy freq | Lead time | Change failure | MTTR |
|------|-------------|-----------|----------------|------|
| **Elite** | On-demand (multiple/day) | <1 hour | 0–15% | <1 hour |
| **High** | Daily–weekly | 1 day–1 week | 16–30% | <1 day |
| **Medium** | Weekly–monthly | 1 week–1 month | 16–30% | <1 day |
| **Low** | Monthly+ | >1 month | 16–30% | 1 week+ |

(Numbers shift slightly each annual report; the *relationships* are stable.)

## Part II — The 24 capabilities

The book maps 24 capabilities that *predictively cause* high performance, organized into five categories:

### Continuous Delivery capabilities
- Version control for all production artifacts
- Deployment automation
- Continuous integration
- Trunk-based development
- Test automation
- Test data management
- Shifting left on security
- Continuous delivery as a practice

### Architecture capabilities
- Loosely-coupled architecture
- Empowered teams (can choose their tools)

### Product & Process capabilities
- Customer feedback
- Value stream visibility
- Working in small batches
- Team experimentation

### Lean Management capabilities
- Lightweight change approval (no CAB review boards for routine changes)
- Monitoring across system + customer
- Proactive notification
- WIP limits
- Visualizing work

### Cultural capabilities
- Westrum organizational culture (generative > pathological)
- Supportive leadership
- Employee satisfaction
- Learning culture
- Job satisfaction
- Transformational leadership

The data shows that orgs improving these capabilities measurably improve the four metrics — and orgs improving the four metrics get better commercial outcomes.

## Part III — Validating the research

Methodology chapter. Survey-based; structural equation modeling. The book is unusual in showing its statistical work and the threats-to-validity discussion. Critics note the survey-data limitation; supporters note the consistency across years.

## Why it matters

- Provides the **empirical foundation** for advocating CD/TBD/automation. "Best practices" claims become "validated practices."
- The **Four Keys** became industry-standard delivery measurement. DORA's continued reports keep them current.
- "Speed and stability are not opposed" is the single most-cited finding.

## Pairs with
- **Continuous Delivery** (Humble & Farley) — the *how*; Accelerate is the *evidence it works*.
- **The DevOps Handbook** (Kim et al.) — operational application.
- **DORA State of DevOps Reports** (annual at dora.dev) — continued empirical updates.
