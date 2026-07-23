---
title: Software Engineering at Google — Lessons Learned from Programming Over Time
authors: Titus Winters, Tom Manshreck, Hyrum Wright (eds.)
year: 2020
category: Engineering Culture & Process
focus: Scale, code review, testing culture, documentation
---

# Software Engineering at Google — Winters, Manshreck, Wright (2020)

A 600-page report from inside one of the largest monorepos on Earth. Distinguishes "programming" (code in a moment) from "software engineering" (code over time, by many people). Free online via O'Reilly.

## Per-part / per-chapter summary

### Part I — Thesis

**Ch 1 — What Is Software Engineering?**
Three axes: time, scale, trade-offs. Hyrum's Law: "with sufficient users of an API, every observable behavior will be relied upon." This is the book's organizing constraint.

**Ch 2 — How to Work Well on Teams**
Three pillars of psychological safety: humility, respect, trust. The "genius myth" is dangerous. Bus factor.

**Ch 3 — Knowledge Sharing**
Codelabs, internal docs, mailing lists, readability reviews. Knowledge is institutional capital — losing it costs more than losing code.

**Ch 4 — Engineering for Equity**
Bias in software designed for an in-group. Diverse teams build better products.

**Ch 5 — How to Lead a Team**
The transition from IC to TL/manager. Servant leadership. The three states (anti-pattern, basic, advanced).

**Ch 6 — Leading at Scale**
Three "always be" rules: deciding, leaving, scaling.

**Ch 7 — Measuring Engineering Productivity**
Goals → signals → metrics (GSM). Don't measure what's easy to measure; measure what matters. QUANTS framework: Quality, Attention, Intellectual complexity, Tempo, Satisfaction.

### Part II — Culture

**Ch 8 — Style Guides and Rules**
Why Google enforces style aggressively. Auto-formatters. Rules need rationale; rules need owners.

**Ch 9 — Code Review**
Code review at Google. Every change reviewed. LGTM and Approval as separate concepts (LGTM = quality; Approval = ownership/policy). Readability reviews for new languages.

**Ch 10 — Documentation**
Treat docs like code: source-controlled, reviewed, owned. Doc types: reference, user, conceptual, landing. The doc rot problem.

**Ch 11 — Testing Overview**
The Beyoncé rule: "if you liked it, you shoulda put a test on it." Test categories, test pyramid.

**Ch 12 — Unit Testing**
Behavior-driven naming. State testing > interaction testing. Brittle test prevention. Tests as documentation.

**Ch 13 — Test Doubles**
Real implementations preferred. Fakes > mocks > stubs. Why mocking is overused. Faking carefully.

**Ch 14 — Larger Testing**
Integration, end-to-end, production probing. Shifting tests left and right.

**Ch 15 — Deprecation**
Adding features is easy; removing them is hard. Strategies: warnings, deprecation policies, automated migration.

### Part III — Processes

**Ch 16 — Version Control and Branch Management**
Trunk-based development. The monorepo. Why feature branches scale poorly.

**Ch 17 — Code Search**
Why a custom code search tool is essential at scale.

**Ch 18 — Build Systems and Build Philosophy**
Bazel-style hermetic builds, distributed caching, deterministic outputs.

**Ch 19 — Critique: Google's Code Review Tool**
The home-grown review tool and why it shapes practice.

**Ch 20 — Static Analysis**
Tricorder framework. Findings must be actionable, easy to fix, low false-positive. Bad analyses get disabled.

**Ch 21 — Dependency Management**
The diamond-dependency problem. SemVer's lies. Live-at-head philosophy.

**Ch 22 — Large-Scale Changes (LSCs)**
Modifying millions of lines across the monorepo. Tooling, owners, batched commits, rollback strategies.

**Ch 23 — Continuous Integration**
Pre-submit tests, post-submit pipelines, flaky-test management, sub-second feedback dreams.

**Ch 24 — Continuous Delivery**
Velocity as a property of the pipeline, not the team. Feature flags, shadow rollouts.

**Ch 25 — Compute as a Service**
Borg → Kubernetes lineage. Why developers shouldn't manage machines.

### Part IV — Conclusion

**Ch 26 — Closing Remarks**
Software engineering is a people problem dressed in code.

## Key sayings
- **Hyrum's Law** — every observable behavior of an API will be relied on.
- **Beyoncé rule** — if you like it, put a test on it.
- **"Live at head"** — don't pin versions; keep dependencies current.

## Why it's deeply integrated into `/quality`
The code-review chapter and testing chapters inform the review-style guidance and the test-quality smells.
