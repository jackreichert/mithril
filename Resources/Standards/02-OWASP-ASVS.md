---
title: OWASP Application Security Verification Standard (ASVS)
publisher: OWASP Foundation
url: owasp.org/www-project-application-security-verification-standard/
category: Standard — Security
focus: Application Security Verification Standard
---

# OWASP ASVS — Application Security Verification Standard

A structured catalog of security requirements grouped into 14 chapters and three verification levels. Current major version: **ASVS v4.0.3** (with v5 in late draft).

## Verification levels

| Level | Audience | What it covers |
|-------|----------|----------------|
| **L1** | Lowest assurance, "first defense" | Common attacks; can be tested without source access |
| **L2** | Most apps with sensitive data | Defense-in-depth; standard for most products |
| **L3** | Critical applications | Compliance with high-trust requirements (banking, healthcare, government) |

## The 14 chapters

1. **Architecture, Design and Threat Modeling** — secure design, threat models, encryption strategy.
2. **Authentication** — credentials, password storage, MFA, session lifecycle.
3. **Session Management** — token generation, expiration, revocation.
4. **Access Control** — authorization model, attribute-based, principle of least privilege.
5. **Validation, Sanitization and Encoding** — input validation, output encoding, deserialization.
6. **Stored Cryptography** — at-rest encryption, key management.
7. **Error Handling and Logging** — log content, log integrity, no PII leakage.
8. **Data Protection** — privacy, data classification, secure deletion.
9. **Communication** — TLS configuration, cert pinning where applicable.
10. **Malicious Code** — supply chain integrity, SBOMs, build provenance.
11. **Business Logic** — abuse-case prevention, anti-automation.
12. **File and Resources** — upload validation, sandbox, anti-virus integration.
13. **API and Web Service** — REST, SOAP, GraphQL hardening.
14. **Configuration** — hardening, secrets management, deployment.

## How to use it

1. Decide target level (L1/L2/L3).
2. Apply the requirements in chapters relevant to your app type.
3. Track verification per requirement (manually, via test, via tool).
4. Use it for **third-party assessment** (RFP language) or **internal threat-model checklist**.

## Pairs with
- **OWASP Top 10** — quick risk overview.
- **OWASP Cheat Sheet Series** — implementation guidance.
- **OWASP ASVS Mobile / IoT** variants for non-web apps.

## Practical tip
Most teams use ASVS as a **menu**, not a full audit — pick the L1 + key L2 items relevant to threat model. Full L3 verification is rare outside regulated industries.
