---
title: Threat Modeling — Designing for Security
author: Adam Shostack
year: 2014
category: Security
focus: the four-question framework, STRIDE, data flow diagrams + trust boundaries, attack trees + libraries, mitigate/eliminate/transfer/accept
---

# Threat Modeling: Designing for Security — Adam Shostack (2014)

The definitive practitioner's handbook on structured threat modeling, written by the engineer who shipped the discipline inside Microsoft's SDL. Feeds the **mithril-security-review** agent: it supplies the *proactive, design-time* "what can go wrong?" discipline that OWASP's reactive vulnerability checklist lacks. The spine is the **four-question framework** — *What are we working on? What can go wrong? What are we going to do about it? Did we do a good job?* — applied to a model (usually a DFD with trust boundaries) before code exists. Backs Article V (validate input at the boundary, design for an adversary); pairs with the OWASP Top 10 as the generative "find threats early" half of the security loop.

## Per-chapter summary

### Part I — Getting Started

### Ch 1 — Dive In and Threat Model!
Learn by doing: draw a data flow diagram, walk STRIDE against each element, file findings as bugs. Introduces the four questions as the through-line and proves you can threat model before reading the theory. Threat modeling is a skill, not a document.

### Ch 2 — Strategies for Threat Modeling
Compares the lenses you can model through: asset-centric, attacker-centric, and software-centric — and argues software-centric (model what you're building) is the most reliable default. Covers DFDs, trust boundaries, and structured brainstorming as the scaffolding for finding threats. Choosing an explicit lens keeps the exercise focused and makes gaps in the model easier for the team to recognize.

### Part II — Finding Threats

### Ch 3 — STRIDE
The workhorse mnemonic — **S**poofing, **T**ampering, **R**epudiation, **I**nformation disclosure, **D**enial of service, **E**levation of privilege — describes violations of authentication, integrity, non-repudiation, confidentiality, availability, and authorization. Apply STRIDE-per-element to every DFD node and data flow to enumerate threats systematically. The mnemonic prompts consistent questions so the team does not depend on one reviewer's memory or intuition.

### Ch 4 — Attack Trees
Attack trees begin with an attacker's goal and decompose it into AND/OR sub-goals. Each branch shows an alternative path or a set of steps that must be combined, creating a structured communication artifact for what can go wrong. They are useful for reasoning about a specific threat in depth, but are weaker than STRIDE as a primary enumeration tool.

### Ch 5 — Attack Libraries
Pre-built catalogs of known attacks (CAPEC, OWASP) used as checklists and prompts. Trade-off: thorough and repeatable, but only as good as the library and prone to anchoring you to known patterns. Best as a supplement to structured enumeration.

### Ch 6 — Privacy Tools
Extends threat modeling beyond security to privacy harms using frameworks like Solove's taxonomy, Nissenbaum's contextual integrity, the LINDDUN methodology, and FIPPs. Privacy threats are about information *flows and uses*, not just breaches. A system can protect data from unauthorized access and still harm people by collecting, combining, retaining, or using it in an unexpected way.

### Part III — Managing and Addressing Threats

### Ch 7 — Processing and Managing Threats
Turn the messy list of found threats into tracked work: prioritize, file as bugs, decide when you've found enough, and manage threat modeling across a project's lifecycle. Tables and risk ranking keep the process from stalling. A threat remains unresolved until it has an owner, a chosen response, and a way to verify that response.

### Ch 8 — Defensive Tactics and Technologies
Maps mitigations directly to STRIDE: authentication answers spoofing, integrity controls answer tampering, logging answers repudiation, encryption/ACLs answer disclosure, and so on. Catalogs concrete tactics and design patterns to address each threat class. Defense in depth combines controls so the failure of one safeguard does not immediately expose the protected asset or operation.

### Ch 9 — Trade-Offs When Addressing Threats
The four responses to a threat are **mitigate** (reduce likelihood/impact), **eliminate** (remove the feature or asset), **transfer** (push risk to another party — insurance, a platform, the user), or **accept** (document and move on). Choosing requires weighing cost, usability, and residual risk. Whatever response is selected, the decision and remaining exposure should be explicit rather than silently inherited by users or operators.

### Ch 10 — Validating That Threats Are Addressed
Close the loop on question four: verify mitigations actually exist in the design and code, test them, and confirm the model still matches what was built. Threat modeling that isn't validated is theater. Revisit both the model and its tests when implementation changes introduce new data flows, components, or trust boundaries.

### Ch 11 — Threat Modeling Tools
Surveys tooling from whiteboards and Visio to the Microsoft SDL Threat Modeling Tool, ThreatModeler, and others. The tool matters less than the discipline; pick one that lowers the friction of drawing models and tracking threats. Avoid allowing a tool's templates or automatic findings to replace the team's understanding of the actual system.

### Part IV — Threat Modeling in Technologies and Tricky Areas

### Ch 12 — Requirements Cookbook
Threats, requirements, and mitigations interlock: a threat implies a requirement, and a requirement implies a control. The chapter provides a cookbook of security and privacy requirements covering compliance and prevent/detect/respond capabilities. This traceability makes each control's purpose visible and gives validation a concrete expected outcome.

### Ch 13 — Web and Cloud Threats
Web and cloud systems introduce remote clients, shared infrastructure, and service dependencies that the application team may not control. The chapter applies threat modeling to account and tenant isolation, multi-tenancy boundaries, and delegated platform responsibilities. Teams must identify which controls belong to them and which guarantees they rely on a provider to enforce.

### Ch 14 — Accounts and Identity
Threat models the full account lifecycle — enrollment, authentication, recovery, and the perennially weak link of "forgot password" flows. Identity is where spoofing lives; treat recovery paths as first-class attack surface. An attacker will choose the easiest lifecycle step, so strong login controls cannot compensate for weak enrollment or recovery.

### Ch 15 — Human Factors and Usability
People are part of the system and the most-exploited element. Covers ceremonies, modeling human decision-making, warning fatigue, and designing security that humans can actually use correctly — usable security is a threat mitigation, not a nicety. Controls that routinely conflict with a person's goal encourage workarounds and should be redesigned rather than blamed on the user.

### Ch 16 — Threats to Cryptosystems
Cryptosystems fail in practice through weak primitives, bad randomness, key management failures, and misuse of otherwise correct algorithms. The recurring lesson is not to roll your own cryptography. Threat model the *system* around the cipher, including key generation, storage, rotation, recovery, and the points where plaintext exists.

### Part V — Taking It to the Next Level

### Ch 17 — Bringing Threat Modeling to Your Organization
Adoption is an organizational change problem: who owns it, where it fits in the lifecycle, how to scale it without it becoming a checkbox, and how to measure that it's working. Make the model living, not a one-time artifact. Training, incentives, review practices, and clear ownership must reinforce the method until it becomes part of ordinary engineering work.

### Ch 18 — Experimental Approaches
The chapter surveys frontier and research methods, including broad threat taxonomies, kill-chain analysis, and alternatives to STRIDE and DFDs. A new method should be evaluated by whether it finds relevant threats more effectively, communicates them more clearly, or reduces the cost of the exercise. Novel terminology alone is not an improvement over a simpler approach that teams can apply consistently.

### Ch 19 — Architecting for Success
An effective threat-modeling practice fits the flow of engineering work and creates boundary objects that different roles can discuss together. Its artifacts must survive long enough to guide implementation, validation, and later changes. Avoid analysis paralysis, asset obsession, and perfectionism because these failure modes consume effort without reducing meaningful risk.

## How it maps to the Constitution
- **Article V (Security & Secrets)** — the proactive, design-time engine for "treat every input as hostile"; STRIDE-per-element finds the boundaries where validation must happen before code exists.
- **Article III (Design & Architecture)** — DFDs + trust boundaries make the dependency arrows and module surfaces explicit; threats cluster exactly at boundary crossings (echoes "across a process boundary, think distributed").
- **Article I (Conflict Precedence)** — Ch 9's mitigate/eliminate/transfer/accept is the security analog of the tie-break order: a recorded, deliberate trade-off, not a silent default.

## Critiques worth knowing
- **STRIDE-and-DFD heavy.** The method shines for software-centric modeling but is verbose; STRIDE-per-element can generate large, repetitive threat lists that demand aggressive prioritization (Ch 7) to stay useful.
- **2014 vintage.** Predates the modern cloud-native, microservice, and supply-chain threat landscape (no SBOM, IaC, or container specifics); the framework still applies, but the technology chapters feel dated.
- **Process can become theater.** Without the validation discipline of Ch 10 and the cultural buy-in of Ch 17, teams produce diagrams nobody acts on — the book warns about this, but it remains the dominant failure mode in practice.
- **Long for a reference.** 19 chapters; most teams adopt the four questions + STRIDE + DFDs and treat the rest as a lookup, which the book's cookbook structure supports.
