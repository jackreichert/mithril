---
title: WCAG 2.2 (Web Content Accessibility Guidelines)
category: Standards
focus: POUR principles, Level AA product floor, mapping to UI review
---

# WCAG 2.2 — Web Content Accessibility Guidelines

W3C recommendation for web (and web-like) accessibility. This note is the **agent-executable floor** for `mithril-accessibility`, not a full certification guide. Canonical: https://www.w3.org/TR/WCAG22/

## Levels

| Level | Role in this library |
|-------|----------------------|
| **A** | Minimum — often insufficient alone for product UI |
| **AA** | **Default product bar** for `/mithril a11y` |
| **AAA** | Aspirational; flag only when project requires it |

## POUR (principles)

1. **Perceivable** — information and UI components presentable to users in ways they can perceive (1.x)
2. **Operable** — UI components and navigation operable (2.x) — keyboard is non-negotiable
3. **Understandable** — information and UI operation understandable (3.x)
4. **Robust** — content robust enough for assistive technologies (4.x) — name, role, value

## High-frequency criteria for code review

| ID | Name | Review signal |
|----|------|---------------|
| 1.1.1 | Non-text content | Missing/meaningless `alt`; icon buttons without names |
| 1.3.1 | Info and relationships | No labels; heading structure; table headers |
| 1.4.1 | Use of color | Errors/status color-only |
| 1.4.3 | Contrast (minimum) | Low-contrast text |
| 2.1.1 | Keyboard | Click-only controls; no focus |
| 2.1.2 | No keyboard trap | Modal/drawer focus trap without exit |
| 2.4.3 | Focus order | Tab order jumps illogically |
| 2.4.7 | Focus visible | Outline removed |
| 2.5.8 | Target size (minimum) | Tiny hit targets (2.2) |
| 3.3.1 / 3.3.2 | Error identification / labels | Unlabeled inputs; silent validation |
| 4.1.2 | Name, Role, Value | Custom widgets without ARIA/state |

## Related

- WAI-ARIA Authoring Practices (APG) — keyboard patterns for complex widgets
- Theme [19 — Accessibility](../Themes/19-Accessibility.md)
- Skill [`skills/accessibility.md`](../../skills/accessibility.md)

## Honest caveats

- Native apps (iOS/Android) use platform guidelines (UIKit/SwiftUI accessibility, Android accessibility) — map POUR, don't force HTML attributes.
- Automated scanners (axe) catch ~30–50% of issues; they don't replace keyboard + AT sampling.
- Legal requirements vary by jurisdiction; AA is the engineering default, not legal advice.
