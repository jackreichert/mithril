# 19 — Accessibility: Inclusive Interfaces

> **Tier 4 · Verification (UI).** Making interactive software usable by people who use keyboards, assistive technology, and diverse sensory/motor profiles — WCAG as the floor, semantic HTML as the default. **Skill:** [`skills/accessibility.md`](../../skills/accessibility.md) · agent `quality-accessibility`.

## The idea in one paragraph

Accessibility is not a coat of paint after design: it is **whether the interface is perceivable, operable, understandable, and robust** (POUR — WCAG). The durable rule is *prefer platform semantics* — real buttons, links, labels, and headings — over reinventing widgets with `div` and ARIA. When custom widgets are necessary, WAI-ARIA Authoring Practices define the keyboard and state contracts. Color alone never carries meaning; focus must be visible; names/roles/values must match what users see. In this library, a11y sits with verification (like review and security): it is a gate on *shipping UI*, not a substitute for domain design. Cross-link Theme 12 when "security" controls (CAPTCHA, timeout) break operable access.

## The arc

- **POUR** — Perceivable (text alternatives, contrast, not color-only); Operable (keyboard, focus, targets, motion); Understandable (labels, errors, language); Robust (name/role/value, valid semantics).
- **HTML first, ARIA second** — ARIA fixes gaps; misuse creates *worse* AT experiences than plain HTML.
- **Forms and dialogs** — the highest bug density: labels, error association, focus trap/restore.
- **Automation + judgment** — axe/linters catch many issues; complex widgets need human APG review.
- **Product bar** — WCAG 2.2 AA is the default product target unless the org states otherwise.

## Key concepts

- WCAG success criteria (AA floor)
- Accessible name / role / value
- Focus management
- APG patterns (dialog, menu, tabs, combobox)
- `prefers-reduced-motion`, contrast, hit targets

## Sources

- WCAG 2.2 (W3C) — [`Resources/Standards/09-WCAG.md`](../Standards/09-WCAG.md)
- WAI-ARIA Authoring Practices (APG)
- HTML semantics (buttons, links, forms, landmarks)
- Inclusive design practice (GOV.UK / Inclusive Components patterns)

## What the skill encodes

- [ ] Keyboard path for primary tasks
- [ ] Labels and errors programmatically associated
- [ ] Contrast and non-color-only status
- [ ] Custom widgets named and operable
- [ ] Modals manage focus correctly

## Connects to

[03 — Readable Code](03-Readable-Code.md) (names for humans include AT users) · [11 — Code Review](11-Code-Review.md) (UI CL review dimensions) · [12 — Security](12-Security-Review.md) (don't break a11y with hostile UX) · [10 — Specification](10-Specification-by-Example.md) (acceptance examples should include AT-critical flows when relevant).
