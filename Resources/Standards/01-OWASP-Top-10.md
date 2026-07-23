---
title: OWASP Top 10
publisher: OWASP Foundation
url: owasp.org/Top10
category: Standard — Security
focus: Web application security risks
---

# OWASP Top 10 — OWASP Foundation

A list of the top ten most critical web application security risks, refreshed every ~3–4 years from real-world data and practitioner survey. Current edition: **OWASP Top 10 — 2021**.

## The 2021 list

### A01:2021 — Broken Access Control
> Restrictions on what authenticated users are allowed to do are often not properly enforced.

Example: changing a URL `/orders/123` to `/orders/124` and seeing another user's order. Highest-frequency category.

### A02:2021 — Cryptographic Failures
> Failures related to cryptography (or lack thereof) which often lead to sensitive data exposure.

Plaintext passwords. TLS not enforced. Weak ciphers. Hardcoded keys.

### A03:2021 — Injection
> User-supplied data is not validated, filtered, or sanitized.

SQLi, XSS, command injection, OS injection, LDAP. Use parameterized queries; sanitize at boundaries.

### A04:2021 — Insecure Design
> Risks related to design and architectural flaws.

New category. Not implementation bugs but architectural ones — missing threat models, lack of secure design patterns. Fix before code, not in code.

### A05:2021 — Security Misconfiguration
Default credentials, verbose errors, unnecessary features enabled, missing headers. Cloud misconfigs (open S3 buckets) belong here.

### A06:2021 — Vulnerable and Outdated Components
> Use of components with known vulnerabilities.

Dependencies with CVEs. Includes transitive deps. Mitigation: SBOMs, dependency scanning, scheduled updates.

### A07:2021 — Identification and Authentication Failures
Broken auth: missing MFA, weak passwords, session fixation, predictable tokens.

### A08:2021 — Software and Data Integrity Failures
> Code and infrastructure that does not protect against integrity violations.

Unsigned packages. Auto-updating without verification. CI/CD pipeline compromise.

### A09:2021 — Security Logging and Monitoring Failures
> Insufficient logging, monitoring, or alerting.

If you can't detect the breach, you can't respond.

### A10:2021 — Server-Side Request Forgery (SSRF)
> Web application is fetching a remote resource without validating the user-supplied URL.

Cloud metadata endpoints (`169.254.169.254`) are common SSRF targets.

## How to use it
- Triage risk during design (A04), code review (A01, A03, A07), CI (A06, A08).
- It's a *checklist*, not a comprehensive standard — pair with **OWASP ASVS** for depth.

## Pairs with
- **OWASP ASVS** — verification standard, 200+ requirements.
- **OWASP Cheat Sheets** — actionable fixes per category.
- **CWE** — programmer-level weakness catalogue.
