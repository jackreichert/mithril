# Calibration Scores

Dated results for the calibration suite. Record one row per case, agent, and model after every prompt change or model upgrade.

Rows dated before 2026-09-23 may name agents since retired (`mithril-specification`, `mithril-patterns`, `mithril-performance`); `expected.yaml` now targets their successors.

Scoring convention: `Caught` and `Missed` count seeded defects from each case's `expected.yaml`. `Critical/Important FPs` counts post-adjudication Critical/Important findings outside the expected list; Minors are not counted.

| Date | Prompt/version | Model | Case | Target agent | Caught | Missed | Critical/Important FPs | Notes |
|------|----------------|-------|------|--------------|--------|--------|------------------------|-------|
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `idor-orders` | `mithril-security-review`, `mithril-flow` | 2 | 0 | 4 | Caught IDOR and SQLi at Critical; extra C/I findings exceeded FP budget. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `n-plus-one` | `mithril-persistence`, `mithril-flow` | 2 | 0 | 2 | Caught N+1 and lost update; precision over budget. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `racy-cache` | `mithril-concurrency` | 3 | 0 | 4 | Caught all seeded concurrency bugs; flagged several extra C/I issues, including clean-bait immutable snapshot path. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `deploy-coupled-migration` | `mithril-delivery` | 1 | 0 | 6 | Caught in-place rename / no expand-contract at Critical; many extra C/I deployment/persistence/code findings. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `mock-internals` | `mithril-test-quality` | 2 | 0 | 2 | Caught private-method spy and sleep-based async wait; extra C/I findings stayed focused on new internals test. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `missing-timeout` | `mithril-distributed`, `mithril-flow` | 2 | 0 | 3 | Caught missing timeout and non-idempotent retry; extra C/I findings on retry policy and amount validation. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `shallow-module-pile` | `mithril-code-quality`, `mithril-architecture` | 2 | 0 | 1 | Caught shallow/pass-through layers at Important; type-only import cycle counted as extra C/I. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `ui-scripted-gherkin` | `mithril-specification` | 1 | 0 | 6 | Caught UI-scripted imperative Gherkin at Critical; extra C/I findings split duplicate rule, UI decoration, positional coupling, sleep, naming. |
| 2026-07-09 | repo baseline after nine-case seeding | Claude Code default via CLI 2.1.181 | `singleton-global` | `mithril-patterns`, `mithril-architecture` | — | — | — | Not scored: Claude CLI returned session-limit message before producing a review. Retry after reset. |
| 2026-07-13 | post-audit optionals (perf/o11y/a11y/PBT skills) | Grok mithril-* agents (smoke monorepo `/tmp/mithril-smoke-ui-api` combining four new cases) | `unbounded-pool` | `mithril-performance` | 2 | 0 | 0 | Caught unbounded fan-out + O(n²); no FP on `exportPage` clean bait. |
| 2026-07-13 | post-audit optionals | Grok `mithril-observability` | `silent-endpoint` | `mithril-observability` | 1 | 0 | 0 | Caught silent `refundOrder`; no FP on `getOrder`/`healthz`. |
| 2026-07-13 | post-audit optionals | Grok `mithril-accessibility` | `div-button-trap` | `mithril-accessibility` | 2 | 0 | 0 | Caught div-as-button + modal focus/Escape; no FP on `LoginForm`. Extra Important on dialog semantics (in-budget). |
| 2026-07-13 | post-audit optionals | Grok `mithril-test-quality` | `happy-path-only-codec` | `mithril-test-quality` | 1 | 0 | 0 | Caught missing PBT/weak oracle on pure codec; no Critical FP on production `encodeSlug`. |