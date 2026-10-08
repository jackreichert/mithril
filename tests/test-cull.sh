#!/usr/bin/env bash
# Tests for scripts/test-cull.sh: each signal must flag its planted bad test and
# spare the good one, and the target repo must come out untouched.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$here/scripts/test-cull.sh"
fx="$here/tests/fixtures/test-cull"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com
fails=0
check() { # name, want-substring, actual
  if [[ "$3" == *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' in '$3'"; fails=$((fails+1)); fi
}
absent() { # name, unwanted-substring, actual
  if [[ "$3" != *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: unexpected '$2'"; fails=$((fails+1)); fi
}

repo="$tmp/repo"; mkdir -p "$repo"; cp -R "$fx/." "$repo/"; rm -f "$repo/mutation.json"
git -C "$repo" init -q -b main
commit() { git -C "$repo" add -A; git -C "$repo" commit -q -m "$1"; }
commit "feat: add calc and tests"
for i in 1 2 3; do # three refactors: production code and test_coupled change, test_good never does
  echo "# refactor $i" >> "$repo/src/calc.py"; echo "# adjust $i" >> "$repo/tests/test_coupled.py"
  commit "refactor(calc): reshape internals $i"
done
echo "# new case" >> "$repo/tests/test_good.py"; commit "test: add a case"
before="$(git -C "$repo" status --porcelain=v1 --untracked-files=all | cksum)$(git -C "$repo" rev-parse HEAD)"

# Run 1: no optional tools. Only change-coupling and duplicates can run; the rest must say so.
"$script" "$repo" --out "$tmp/o1" >/dev/null; r1="$(cat "$tmp/o1/report.json")"; m1="$(cat "$tmp/o1/report.md")"
check "coupling flags the refactor-coupled test" '"file": "tests/test_coupled.py"' "$r1"
check "coupling evidence is a ratio" "changed in 3 of 3 refactor commits" "$r1"
check "duplicate assertions flagged" '"file": "tests/test_dup.py"' "$r1"
absent "good test is spared" "tests/test_good.py" "$r1"
check "flaky reported as not run" '"signal": "flaky", "status": "not run"' "$r1"
check "mutation reported as not run" '"signal": "mutation", "status": "not run"' "$r1"
check "no score is invented" '"mutation_score_pct": null' "$r1"
check "markdown says not measured" "Mutation score: not measured" "$m1"
check "markdown carries the retention bar" "never delete a test that independently guards" "$m1"

# Run 2: flaky and slow through the JUnit contract.
"$script" "$repo" --out "$tmp/o2" --test-cmd "bash tools/fake-runner.sh" --runs 3 >/dev/null; r2="$(cat "$tmp/o2/report.json")"
check "flaky test flagged" '"signal": "flaky", "evidence": "failed 1 of 3 runs' "$r2"
check "slow test flagged" '"signal": "slow", "evidence": "mean 2.50s' "$r2"
check "flaky maps to its file" '"file": "tests/test_flaky.py"' "$r2"
check "flaky (3) ranks above slow-only (1)" '"rank": 2, "file": "tests/test_flaky.py"' "$r2"
# pytest-style rows carry no file=: the dotted classname must merge into the coupled file's row.
check "classname maps into the file's existing row" '"file": "tests/test_coupled.py", "score": 3' "$r2"
check "merged row carries both signals" '"signal": "slow", "evidence": "mean 3.00s (tests.test_coupled.TestInternals::test_slow_helper)' "$r2"
absent "no row keyed by a dotted classname" '"file": "tests.' "$r2"
absent "path-style classname that passes is not a candidate" "test_pathy" "$r2"
absent "stable fast test is spared" "tests/test_good.py" "$r2"
"$script" "$repo" --out "$tmp/o2b" --test-cmd "bash tools/fake-runner.sh" --runs 1 >/dev/null
check "one run cannot show flakiness" '"signal": "flaky", "status": "not run"' "$(cat "$tmp/o2b/report.json")"
"$script" "$repo" --out "$tmp/o2c" --test-cmd "true" >/dev/null
check "runner without JUnit output is reported" "wrote no JUnit XML" "$(cat "$tmp/o2c/report.json")"

# Run 3: mutation (needs jq) and baseline numbers.
if command -v jq >/dev/null 2>&1; then
  "$script" "$repo" --out "$tmp/o3" --mutation-report "$fx/mutation.json" --coverage-pct 80 >/dev/null; r3="$(cat "$tmp/o3/report.json")"
  check "mutation flags the test that kills nothing" '"file": "tests/test_never_kills.py"' "$r3"
  check "mutation evidence names the test" "covers 4 mutants, kills none: test_smoke" "$r3"
  absent "mutation spares the killing test" "tests/test_good.py" "$r3"
  check "mutation score recorded" '"mutation_score_pct": 75' "$r3"
  check "coverage recorded" '"coverage_pct": 80' "$r3"
  check "mutation ranks first" '"rank": 1, "file": "tests/test_never_kills.py"' "$r3"
  "$script" "$repo" --out "$tmp/o4" --mutation-report "$fx/mutation.json" --coverage-pct 70 --compare "$tmp/o3/report.json" >/dev/null
  check "coverage drop detected" "coverage_pct: DROPPED (80 -> 70)" "$(cat "$tmp/o4/report.md")"
  check "unchanged mutation score is no drop" "mutation_score_pct: no drop (75 -> 75)" "$(cat "$tmp/o4/report.md")"
  "$script" "$repo" --out "$tmp/o5" --mutation-report "$fx/mutation.json" --compare "$tmp/o3/report.json" >/dev/null
  check "unmeasured coverage cannot prove anything" "coverage_pct: CANNOT PROVE (not measured in this run)" "$(cat "$tmp/o5/report.md")"
  echo '{"files": {}}' > "$tmp/empty.json"
  "$script" "$repo" --out "$tmp/o6" --mutation-report "$tmp/empty.json" >/dev/null
  check "empty mutation report gives no score" '"mutation_score_pct": null' "$(cat "$tmp/o6/report.json")"
else
  echo "skip mutation tests: jq not installed"
fi

# Playbook structure that the reviews found broken: schedule re-armed before any stop path,
# baseline taken from a recorded path, coverage measured without counting test files.
pb="$(cat "$here/playbooks/test-cull.md")"
rearm_line="$(grep -n 'event-loop.ts add' "$here/playbooks/test-cull.md" | head -1 | cut -d: -f1)"
stop_line="$(grep -n 'stop and report' "$here/playbooks/test-cull.md" | head -1 | cut -d: -f1)"
check "playbook re-arms the schedule before the first stop path" "yes" "$([ "$rearm_line" -lt "$stop_line" ] && echo yes)"
absent "playbook compares against a recorded baseline, not today's OUT" "--compare \"\$OUT/report.json\"" "$pb"
check "playbook names an explicit baseline variable" 'BASELINE=/absolute/path' "$pb"
check "playbook coverage omits test files" '--cov-config=' "$pb"
absent "playbook has no bare --cov coverage command" '--cov --cov-report' "$pb"

# A missing --compare file must fail before the suite runs, not after.
cmp_out="$("$script" "$repo" --out "$tmp/o11" --test-cmd "touch $tmp/ran-marker" --compare "$tmp/nope.json" 2>&1)"; cmp_rc=$?
check "missing compare file is refused" "cannot read --compare file" "$cmp_out"
check "missing compare file exits 2" "2" "$cmp_rc"
absent "missing compare file refused before any run" "x" "$([ -e "$tmp/ran-marker" ] && echo x)"

# Coverage via command, and guards.
"$script" "$repo" --out "$tmp/o7" --coverage-cmd 'echo noise; echo 91.5%' >/dev/null
check "coverage-cmd last line parsed" '"coverage_pct": 91.5' "$(cat "$tmp/o7/report.json")"
check "out inside repo is refused" "must be outside the target repo" "$("$script" "$repo" --out "$repo/report" 2>&1)"
absent "refused out dir is never created" "x" "$([ -e "$repo/report" ] && echo x)"
"$script" "$repo" --out "$repo/reports/deep/cull" >/dev/null 2>&1
absent "nested refused out creates no directories" "x" "$([ -e "$repo/reports" ] && echo x)"
"$script" "$repo" --out "$tmp/nope/../repo/q" >/dev/null 2>&1; rc=$?
absent "dotdot through a missing dir creates nothing in the repo" "x" "$([ -e "$repo/q" ] && echo x)"
absent "dotdot through a missing dir creates no stray dir" "x" "$([ -e "$tmp/nope" ] && echo x)"
check "dotdot through a missing dir is refused" "2" "$rc"
ln -s "$repo" "$tmp/link"; "$script" "$repo" --out "$tmp/link/viasym" >/dev/null 2>&1
absent "symlinked route into the repo creates nothing" "x" "$([ -e "$repo/viasym" ] && echo x)"
mkdir -p "$tmp/plain"; check "non-git dir is refused" "not a git repository" "$("$script" "$tmp/plain" --out "$tmp/o8" 2>&1)"

# Suite writes under an ignored node_modules must stay in the temp copy.
nm="$tmp/nmrepo"; mkdir -p "$nm"; cp -R "$fx/." "$nm/"; rm -f "$nm/mutation.json"; mkdir -p "$nm/node_modules/pkg"
echo "node_modules/" > "$nm/.gitignore"; echo x > "$nm/node_modules/pkg/index.js"
git -C "$nm" init -q -b main; git -C "$nm" add -A; git -C "$nm" commit -q -m "chore: init"
"$script" "$nm" --out "$tmp/o9" --test-cmd 'echo cache > node_modules/pkg/cache.json; bash tools/fake-runner.sh' --runs 2 >/dev/null
absent "suite write into node_modules never reaches the repo" "x" "$([ -e "$nm/node_modules/pkg/cache.json" ] && echo x)"
absent "clean run has no warning" "WARNING" "$(cat "$tmp/o9/report.md")"
check "clean run states the tree check" "ignored files included" "$(cat "$tmp/o9/report.md")"
# A command that really writes into the repo (ignored path, invisible to git status) must be caught.
"$script" "$nm" --out "$tmp/o10" --coverage-cmd "echo hit > $nm/node_modules/pkg/leak.json; echo 50" >/dev/null
check "ignored-file write into the repo is reported" "WARNING: the target repo was modified" "$(cat "$tmp/o10/report.md")"
rm -f "$nm/node_modules/pkg/leak.json"

after="$(git -C "$repo" status --porcelain=v1 --untracked-files=all | cksum)$(git -C "$repo" rev-parse HEAD)"
check "target repo untouched by every run" "$before" "$after"
absent "report states repo unchanged" "WARNING" "$m1"
exit $((fails > 0))
