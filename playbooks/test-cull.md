# Playbook: periodic test cull (report only)

For a small model. Run the commands exactly as written, in order. You never delete, edit, rename, or skip a test. The owner approves every deletion.

Why this exists: a suite is code you maintain forever, and a test that cannot fail, breaks on safe refactors, flakes, or runs slow costs more than it protects (`Resources/Themes/09-Test-Quality.md`). Mutation is the direct measure of whether a suite can fail (`Resources/Themes/13-Gates-and-Metrics.md`). The change-coupling and duplicate-line signals are this repo's own heuristics, not sourced rules, so treat them as hints.

The script runs the target repo's tests only in a temp copy, then checks that no file in the repo changed (ignored files included). It prints a WARNING if one did; trust that line.

## 1. Set three variables

Replace only the first line (the repo to cull); keep the other two.

```bash
REPO=/absolute/path/to/the/repo/to/cull
MITHRIL=/Users/aryajack/dev-env/skills/mithril
OUT="$HOME/test-cull-reports/$(basename "$REPO")-$(date +%Y%m%d)"
```

`OUT` is outside `REPO` on purpose; the script refuses an `--out` inside the repo.

## 2. Run the script (pick the block that matches the repo)

Python with pytest. `-o junit_family=xunit1` puts the file path in the report. This command was run against a real pytest repo:

```bash
bash "$MITHRIL/scripts/test-cull.sh" "$REPO" --out "$OUT" --runs 3 \
  --test-cmd 'python3 -m pytest -q -p no:cacheprovider -o junit_family=xunit1 --junitxml="$MITHRIL_JUNIT_OUT"'
```

Add coverage when `pytest-cov` is installed (`python3 -c "import pytest_cov"` prints nothing and exits 0). Append this line to the command above, after adding a trailing `\` to its last line (not run here; pytest-cov was not installed):

```bash
  --coverage-cmd 'python3 -m pytest -q -p no:cacheprovider --cov --cov-report=term | awk "/^TOTAL/{print \$NF}"'
```

JavaScript or TypeScript with Jest and `jest-junit` installed in the repo (not run on a real project; if it fails the report says `not run` with the reason):

```bash
bash "$MITHRIL/scripts/test-cull.sh" "$REPO" --out "$OUT" --runs 3 \
  --test-cmd 'JEST_JUNIT_OUTPUT_FILE="$MITHRIL_JUNIT_OUT" JEST_JUNIT_CLASSNAME="{filepath}" npx --no-install jest --ci --reporters=jest-junit'
```

Any other stack, or when unsure: no test command. Coupling and duplicates still run; flaky and slow say `not run`.

```bash
bash "$MITHRIL/scripts/test-cull.sh" "$REPO" --out "$OUT"
```

Mutation: if the repo already has a Stryker mutation report, add `--mutation-report /absolute/path/to/mutation.json`. Do not install anything. Without it the report says mutation `not run`; that is fine.

If the script exits non-zero, stop and report its error line.

## 3. Read `$OUT/report.md`

1. Baseline: write down coverage and mutation score. If either says `not measured`, say so loudly; a later run cannot prove it did not drop.
2. Signals table: note which signals ran and which did not.
3. Candidates table: already ranked, top to bottom.
4. The last line must say no file in the repo was modified. If it starts with WARNING, stop and report it.

## 4. Report to the owner

Send, in this order: the baseline numbers, which signals ran or did not, then each candidate as one line: file, score, suggested action, the evidence. Add the paths `$OUT/report.md` and `$OUT/report.json`. Then stop. Do not touch any test.

## 5. Re-arm the schedule

The event loop's `reminder` type fires once, so register the next one each time you finish a run. This sets the next cull 30 days out (macOS `date`):

```bash
node /Users/aryajack/dev-env/skills/the-maestro/scripts/event-loop.ts add \
  --id "test-cull-$(basename "$REPO")" --type reminder \
  --target "$(date -u -v+30d +%Y-%m-%dT%H:%M:%SZ)" \
  --report "Run playbooks/test-cull.md from $MITHRIL on $REPO, report the candidates, then re-arm this reminder"
```

This `add` form was run against a throwaway event dir and registered. If a reminder with that id is already registered and `add` complains, run `node /Users/aryajack/dev-env/skills/the-maestro/scripts/event-loop.ts remove "test-cull-$(basename "$REPO")"` and add again. The reminder carries no secrets.

Choice made where the ticket was ambiguous: the event loop has no recurring-timer type, so a one-shot reminder re-armed at the end of every run is the schedule. A standing recurring type would be a change to the-maestro, not to this repo.

## 6. After the owner approves some deletions (only then)

The owner or a writer agent makes the change. Rerun step 2 with the same options, plus `--compare "$OUT/report.json"` and a new `--out` (for example `OUT="$OUT-after"`). Report the Comparison section of the new `report.md` verbatim. `DROPPED` or `CANNOT PROVE` on coverage or mutation means the cull is not proven safe: say so.

## Never

- Never delete, edit, rename, or skip a test, or mark it quarantined.
- Never recommend deleting a test that guards a public API, protocol, config, migration, storage, security, or release contract. The retention bar in `skills/test-quality.md` wins over any score.
- Never invent a number for a signal that did not run.
