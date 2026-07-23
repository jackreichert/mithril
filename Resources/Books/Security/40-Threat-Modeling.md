---
title: Threat Modeling — Designing for Security
author: Adam Shostack
year: 2014
category: Security
focus: the four-question framework, STRIDE, data flow diagrams + trust boundaries, attack trees + libraries, mitigate/eliminate/transfer/accept
---

# Threat Modeling: Designing for Security — Adam Shostack (2014)

The definitive practitioner's handbook on structured threat modeling, written by the engineer who shipped the discipline inside Microsoft's SDL. Feeds the **quality-security-review** agent: it supplies the *proactive, design-time* "what can go wrong?" discipline that OWASP's reactive vulnerability checklist lacks. The spine is the **four-question framework** — *What are we working on? What can go wrong? What are we going to do about it? Did we do a good job?* — applied to a model (usually a DFD with trust boundaries) before code exists. Backs Article V (validate input at the boundary, design for an adversary); pairs with the OWASP Top 10 as the generative "find threats early" half of the security loop.

## Per-chapter summary

### Part I — Getting Started

### Ch 1 — Dive In and Threat Model!
Learn by doing: draw a data flow diagram, walk STRIDE against each element, file findings as bugs. Introduces the four questions as the through-line and proves you can threat model before reading the theory. Threat modeling is a skill, not a document.

### Ch 2 — Strategies for Threat Modeling
Compares the lenses you can model through: asset-centric, attacker-centric, and software-centric — and argues software-centric (model what you're building) is the most reliable default. Covers DFDs, trust boundaries, and structured brainstorming as the scaffolding for finding threats.

### Part II — Finding Threats

### Ch 3 — STRIDE
The workhorse mnemonic — **S**poofing, **T**ampering, **R**epudiation, **I**nformation disclosure, **D**enial of service, **E**levation of privilege — each the violation of a desirable property (authentication, integrity, non-repudiation, confidentiality, availability, authorization). Apply STRIDE-per-element to every DFD node and data flow to enumerate threats systematically.

### Ch 4 — Attack Trees
Goal-rooted trees that decompose an attacker's objective into AND/OR sub-goals, giving structure and a communication artifact for "what can go wrong." Useful for reasoning about a specific threat in depth; weaker as a primary enumeration tool than STRIDE.

### Ch 5 — Attack Libraries
Pre-built catalogs of known attacks (CAPEC, OWASP) used as checklists and prompts. Trade-off: thorough and repeatable, but only as good as the library and prone to anchoring you to known patterns. Best as a supplement to structured enumeration.

### Ch 6 — Privacy Tools
Extends threat modeling beyond security to privacy harms using frameworks like Solove's taxonomy, Nissenbaum's contextual integrity, the LINDDUN methodology, and FIPPs. Privacy threats are about information *flows and uses*, not just breaches.

### Part III — Managing and Addressing Threats

### Ch 7 — Processing and Managing Threats
Turn the messy list of found threats into tracked work: prioritize, file as bugs, decide when you've found enough, and manage threat modeling across a project's lifecycle. Tables and risk ranking keep the process from stalling.

### Ch 8 — Defensive Tactics and Technologies
Maps mitigations directly to STRIDE: authentication answers spoofing, integrity controls answer tampering, logging answers repudiation, encryption/ACLs answer disclosure, and so on. Catalogs concrete tactics and design patterns to address each threat class.

### Ch 9 — Trade-Offs When Addressing Threats
The four responses to a threat: **mitigate** (reduce likelihood/impact), **eliminate** (remove the feature or asset), **transfer** (push risk to another party — insurance, a platform, the user), or **accept** (document and move on). Choosing requires weighing cost, usability, and residual risk.

### Ch 10 — Validating That Threats Are Addressed
Close the loop on question four: verify mitigations actually exist in the design and code, test them, and confirm the model still matches what was built. Threat modeling that isn't validated is theater.

### Ch 11 — Threat Modeling Tools
Surveys tooling from whiteboards and Visio to the Microsoft SDL Threat Modeling Tool, ThreatModeler, and others. The tool matters less than the discipline; pick one that lowers the friction of drawing models and tracking threats.

### Part IV — Threat Modeling in Technologies and Tricky Areas

### Ch 12 — Requirements Cookbook
Threats, requirements, and mitigations interlock: a threat implies a requirement, a requirement implies a control. Provides a cookbook of security/privacy requirements (compliance, prevent/detect/respond) to drive and check your model.

### Ch 13 — Web and Cloud Threats
Applies the method to web and cloud specifics: account/tenant isolation, the trust boundaries introduced by multi-tenancy and shared infrastructure, and the threats that arise when you don't own the stack.

### Ch 14 — Accounts and Identity
Threat models the full account lifecycle — enrollment, authentication, recovery, and the perennially weak link of "forgot password" flows. Identity is where spoofing lives; treat recovery paths as first-class attack surface.

### Ch 15 — Human Factors and Usability
People are part of the system and the most-exploited element. Covers ceremonies, modeling human decision-making, warning fatigue, and designing security that humans can actually use correctly — usable security is a threat mitigation, not a nicety.

### Ch 16 — Threats to Cryptosystems
What goes wrong with crypto in practice: weak primitives, bad randomness, key management failures, and misuse of correct algorithms. The recurring lesson — don't roll your own; threat model the *system* around the crypto, not just the cipher.

### Part V — Taking It to the Next Level

### Ch 17 — Bringing Threat Modeling to Your Organization
Adoption is an organizational change problem: who owns it, where it fits in the lifecycle, how to scale it without it becoming a checkbox, and how to measure that it's working. Make the model living, not a one-time artifact.

### Ch 18 — Experimental Approaches
Surveys frontier and research methods — broad threat taxonomies, "kill chain" analysis, alternative methodologies — and how to evaluate whether a new approach actually improves on STRIDE-and-DFDs.

### Ch 19 — Architecting for Success
Synthesis: the qualities of an effective threat-modeling practice — flow, boundary objects, artifacts that survive, and avoiding the failure modes (analysis paralysis, asset obsession, perfectionism) that sink programs.

## How it maps to the Constitution
- **Article V (Security & Secrets)** — the proactive, design-time engine for "treat every input as hostile"; STRIDE-per-element finds the boundaries where validation must happen before code exists.
- **Article III (Design & Architecture)** — DFDs + trust boundaries make the dependency arrows and module surfaces explicit; threats cluster exactly at boundary crossings (echoes "across a process boundary, think distributed").
- **Article I (Conflict Precedence)** — Ch 9's mitigate/eliminate/transfer/accept is the security analog of the tie-break order: a recorded, deliberate trade-off, not a silent default.

## Critiques worth knowing
- **STRIDE-and-DFD heavy.** The method shines for software-centric modeling but is verbose; STRIDE-per-element can generate large, repetitive threat lists that demand aggressive prioritization (Ch 7) to stay useful.
- **2014 vintage.** Predates the modern cloud-native, microservice, and supply-chain threat landscape (no SBOM, IaC, or container specifics); the framework still applies, but the technology chapters feel dated.
- **Process can become theater.** Without the validation discipline of Ch 10 and the cultural buy-in of Ch 17, teams produce diagrams nobody acts on — the book warns about this, but it remains the dominant failure mode in practice.
- **Long for a reference.** 19 chapters; most teams adopt the four questions + STRIDE + DFDs and treat the rest as a lookup, which the book's cookbook structure supports.
