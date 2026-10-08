# Playbook: periodic test cull (report only)

For a small model. Do the steps in order. You never delete, edit, or move a test. The owner approves every deletion.

Why this exists: a suite is code you maintain forever, and a test that cannot fail, breaks on safe refactors, flakes, or runs slow costs more than it protects (`Resources/Themes/09-Test-Quality.md`). Mutation is the direct measure of whether a suite can fail (`Resources/Themes/13-Gates-and-Metrics.md`). The change-coupling and duplicate-line signals are this repo's own heuristics, not sourced rules, so treat them as hints.

## 1. Run the script

```bash
bash scripts/test-cull.sh REPO_PATH --out OUT_DIR \
  [--mutation-report mutation.json | --run-mutation] \
  [--test-cmd 'COMMAND THAT WRITES JUNIT XML TO $MITHRIL_JUNIT_OUT' --runs 3] \
  [--coverage-pct N | --coverage-cmd 'COMMAND PRINTING A PERCENT ON ITS LAST LINE']
```

- `OUT_DIR` must be outside `REPO_PATH`. The script refuses otherwise and never writes to the repo.
- Pass only the options the repo supports. Do not install tools. A signal that cannot run is listed as `not run` with the reason; that is fine.
- If it exits non-zero, stop and report the error line.

## 2. Read `OUT_DIR/report.md`

1. Baseline: write down coverage and mutation score. If either says `not measured`, say so loudly; a later run cannot prove it did not drop.
2. Signals table: note which signals ran and which did not.
3. Candidates table: top to bottom, already ranked.
4. Last line must say the target repo status was unchanged. If it says WARNING, stop and report that.

## 3. Report to Jack

Send, in this order: the baseline numbers, which signals ran or did not, then each candidate as one line: file, score, suggested action, the evidence. Add the path to `report.md` and `report.json`.

## 4. After Jack approves some deletions (only then)

Jack or a writer agent makes the change. Rerun step 1 with the same options plus `--compare OUT_DIR/report.json` and a new `--out`. Report the Comparison section verbatim. `DROPPED` or `CANNOT PROVE` on coverage or mutation means the cull is not proven safe: say so.

## Never

- Never delete, edit, rename, or skip a test, or mark it quarantined.
- Never recommend deleting a test that guards a public API, protocol, config, migration, storage, security, or release contract. The retention bar in `skills/test-quality.md` wins over any score.
- Never invent a number for a signal that did not run.
