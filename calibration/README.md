# Calibration Suite — does the harness actually work?

Golden diffs with **seeded, labeled defects**, used to measure the review harness's catch rate and false-positive rate — per agent, per model. Run it after any prompt change and after any model upgrade; without it, "the agents got better/worse" is vibes.

## Layout

```text
calibration/
├── README.md          # this file — the protocol
├── run.sh             # stages a case as a git diff and invokes /quality on it
├── SCORES.md          # dated run log; starts empty until the first scored run
└── cases/
    └── <case-name>/
        ├── base/      # the "before" tree (committed as the base)
        ├── changed/   # the "after" tree (staged as the diff under review)
        └── expected.yaml  # the seeded defects + allowed false-positive budget
```

## The protocol

1. **Each case seeds 1–3 labeled defects** in `changed/` relative to `base/`, plus *deliberately clean* surrounding code (the false-positive bait — clean code the harness must NOT flag).
2. `expected.yaml` lists each seeded defect: `id`, `agent` (who should catch it), `file`, `severity_min`, and a `match` hint (substring/regex the finding should contain).
3. `run.sh <case>` builds a throwaway git repo (base committed, changed staged), then prints the `claude -p '/quality'` invocation to run inside it (or runs it, if the `claude` CLI is available non-interactively).
4. **Score manually or by grep:** each expected defect found at ≥ its `severity_min` = a catch. Each Critical/Important finding *not* in the expected list = a false positive (Minors are not counted as FPs — they're judgment).
5. Track results in `SCORES.md` (a dated table: case × agent × model → caught / missed / FP count). It exists as the run log; until the first scored calibration pass, it should say that no runs have been recorded. The trend is the product.

## Scoring targets

- **Catch rate ≥ 80%** on seeded Critical/Important defects.
- **False positives ≤ 1 per case** at Critical/Important after the orchestrator's adjudication pass.
- A case that every model always passes teaches nothing — retire it and seed a harder one.

## Prompt compression benchmark

Treat prompt slimming as a non-inferiority experiment. Change one agent at a time.

### 1. Freeze the baseline

Keep an immutable copy of the original agent outside the active bundle and record its size:

```bash
bash calibration/prompt-size.sh /path/to/baseline-agent.md
```

Record the exact model/version, orchestrator prompt, case revision, and run count. Do not compare different model versions.

### 2. Run behavioral A/B trials

Run the baseline and candidate against the same relevant seeded cases at least three times each. Use fresh sessions and identical model settings to expose model variance. Score every run against `expected.yaml` and record it in `SCORES.md`.

For a specialist agent, start with its targeted cases, then run the full suite before merging because shorter prompts can alter orchestrator routing and cross-agent false positives.

```bash
bash calibration/run.sh shallow-module-pile --keep
```

### 3. Enforce non-inferiority

A compressed prompt passes only when all gates hold:

| Measure | Candidate gate |
| ------- | -------------- |
| Seeded-defect recall | No more than 5 percentage points below baseline; still ≥80% overall |
| Critical defects | No misses that the baseline caught |
| Severity | No seeded finding drops below `severity_min` |
| Critical/Important false positives | No increase in mean per case; still ≤1 per case |
| Stability | Every seeded defect caught by the baseline is caught in at least 2 of 3 candidate runs |
| Prompt size | At least 30% fewer words, or a documented exception in the run's `SCORES.md` notes |
| Static contracts | `bash healthcheck.sh` passes |

Use the word budget as an executable regression gate after choosing the accepted candidate size:

```bash
bash calibration/prompt-size.sh --max-words 1400 \
    skills/code-quality.md
```

The token value is estimated from bytes and is useful for trend comparison, not billing. Behavioral calibration remains the fidelity gate.

## Seed cases (the pattern — extend to ≥1 per agent domain)

| Case | Seeded defects | Target agents |
| ---- | -------------- | ------------- |
| `idor-orders` | Handler loads a resource by client-supplied ID with no ownership check; string-built SQL | quality-security-review, quality-flow |
| `n-plus-one` | Loop calling a per-item repository query across files; blind write across user think-time (lost update) | quality-persistence, quality-flow |
| `racy-cache` | Unsynchronized lazy singleton; check-then-act across an await; un-awaited async write | quality-concurrency |
| `deploy-coupled-migration` | In-place column rename shipped with the code that needs it — breaks the previous release (no expand-contract) | quality-delivery |
| `mock-internals` | Test spies on the SUT's own private method + asserts call order; sleep-based async wait | quality-test-quality |
| `missing-timeout` | POST with no timeout; retry loop around a non-idempotent payment capture with no idempotency key | quality-distributed, quality-flow |
| `shallow-module-pile` | Direct function call wrapped in pass-through controller/mapper/service classes with no added policy or abstraction | quality-code-quality, quality-architecture |
| `ui-scripted-gherkin` | Business acceptance scenario written as imperative browser steps with selectors, colors, and sleeps | quality-specification |
| `singleton-global` | Constructor-injected policy replaced by a mutable process-wide Singleton registry | quality-patterns, quality-architecture |
| `unbounded-pool` | Thread pool with unbounded queue + hot-path O(n²) over full customer list; clean path uses bounded executor + keyset page | quality-performance |
| `silent-endpoint` | New HTTP handler ships with no metrics/logs/trace context; structured healthz is the clean bait | quality-observability |
| `div-button-trap` | Custom div-"button" without keyboard/name; modal focus trap with no Escape; labeled form is clean bait | quality-accessibility |
| `happy-path-only-codec` | Pure encode/decode algebra covered by one happy-path unit test only; no round-trip property / edge generators | quality-test-quality |

Coverage note: the suite aims for ≥1 seed case per specialist domain (including performance, observability, accessibility). Add harder variants when a model consistently passes a case with no false positives.

## Why cases live as file trees, not `.patch` files

The agents read surrounding context with Read/Grep — a patch alone under-specifies what they'd actually see. A real staged diff in a real (throwaway) repo reproduces the true input distribution of `/quality`.
