#!/usr/bin/env bash
# Periodic test cull: rank the tests of a repo that may cost more than they protect.
# REPORT ONLY. Never edits or deletes a test; the target repo is read-only (every
# test or mutation run happens in a temp copy, and a status check at the end
# proves the repo was left as found). A human approves each deletion.
#
# Usage: test-cull.sh REPO [options]
#   --out DIR              report directory (default ./test-cull-report; must be outside REPO)
#   --history N            commits of history for change-coupling (default 200)
#   --min-refactors N      fewest refactor commits before coupling counts (default 3)
#   --coupling-ratio R     share of refactor commits that must touch a test (default 0.5)
#   --dup-min N            same assertion line in at least N places (default 3)
#   --test-cmd CMD         runs the suite in a temp copy and writes JUnit XML to
#                          $MITHRIL_JUNIT_OUT; enables the flaky and slow signals
#   --runs N               times to run --test-cmd (default 3; flaky needs >= 2)
#   --slow-seconds S       mean seconds at or above which a test is slow (default 1)
#   --mutation-report F    Stryker-format mutation.json (jq required)
#   --run-mutation         run the repo's own Stryker config in a temp copy (opt-in)
#   --coverage-pct P       coverage percent measured by the caller
#   --coverage-cmd CMD     runs in a temp copy; last stdout line is a coverage percent
#   --compare PREV.json    compare this run's baseline with an earlier report.json
# Signals that cannot run are listed as not run, with the reason; no score is invented.
set -euo pipefail

repo=""; out="./test-cull-report"; history=200; min_refactors=3; ratio=0.5; dup_min=3
test_cmd=""; runs=3; slow_s=1; mut_report=""; run_mut=0; cov_pct=""; cov_cmd=""; prev=""
die() { echo "test-cull: $*" >&2; exit 2; }
while [ $# -gt 0 ]; do
  case "$1" in
    --out) out="${2:?}"; shift 2 ;; --history) history="${2:?}"; shift 2 ;;
    --min-refactors) min_refactors="${2:?}"; shift 2 ;; --coupling-ratio) ratio="${2:?}"; shift 2 ;;
    --dup-min) dup_min="${2:?}"; shift 2 ;; --test-cmd) test_cmd="${2:?}"; shift 2 ;;
    --runs) runs="${2:?}"; shift 2 ;; --slow-seconds) slow_s="${2:?}"; shift 2 ;;
    --mutation-report) mut_report="${2:?}"; shift 2 ;; --run-mutation) run_mut=1; shift ;;
    --coverage-pct) cov_pct="${2:?}"; shift 2 ;; --coverage-cmd) cov_cmd="${2:?}"; shift 2 ;;
    --compare) prev="${2:?}"; shift 2 ;; -h | --help) sed -n '2,24p' "$0"; exit 0 ;;
    -*) die "unknown option $1" ;; *) [ -z "$repo" ] || die "one REPO only"; repo="$1"; shift ;;
  esac
done
[ -n "$repo" ] || die "usage: test-cull.sh REPO [options]"
repo="$(cd "$repo" && pwd -P)"
git -C "$repo" rev-parse --show-toplevel >/dev/null 2>&1 || die "$repo is not a git repository"
[ "$(git -C "$repo" rev-parse --show-toplevel)" = "$repo" ] || die "$repo is not a repository root"
resolve_path() { # absolute, symlink-resolved form of a path that may not exist yet
  local p="$1" rest=""
  while [ ! -e "$p" ]; do rest="/$(basename "$p")$rest"; p="$(dirname "$p")"; done
  printf '%s%s' "$(cd "$p" && pwd -P)" "$rest"
}
out="$(resolve_path "$out")"
case "$out/" in "$repo"/*) die "--out must be outside the target repo (read-only guarantee)" ;; esac
mkdir -p "$out"

work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
sig="$work/signals.tsv"; : > "$sig"
status_file="$work/status.tsv"; : > "$status_file"
# Test files: common conventions across Python, JS/TS, Go, Java, Ruby, Rust.
test_re='(^|/)(tests?|__tests__|spec|specs)/|(^|/)test_[^/]*\.py$|[._-](test|spec)\.[A-Za-z]+$|_test\.go$|Tests?\.java$'
git -C "$repo" ls-files | grep -E "$test_re" > "$work/testfiles" || true
# Read-only proof: nothing outside .git modified after this marker (ignored files such as
# node_modules included), and HEAD plus status unchanged.
touch "$work/start-marker"; sleep 1
before_state="$(git -C "$repo" rev-parse HEAD 2>/dev/null)$(git -C "$repo" status --porcelain=v1 --untracked-files=all | cksum)"

mark() { printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$status_file"; }  # signal, ran|not run, detail
emit() { printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" >> "$sig"; }  # file, signal, weight, evidence

make_copy() { # tracked + untracked-not-ignored files, working-tree state, into $work/copy
  [ -d "$work/copy" ] && return 0
  mkdir -p "$work/copy"
  (cd "$repo" && git ls-files -co --exclude-standard -z | tar --null -T - -cf -) | tar -x -C "$work/copy"
  # Dependency dirs are ignored by git, so copy them (a symlink would let the suite write into the repo).
  if [ -d "$repo/node_modules" ]; then cp -cR "$repo/node_modules" "$work/copy/node_modules" 2>/dev/null || cp -R "$repo/node_modules" "$work/copy/node_modules"; fi
  return 0
}

# ---- signal: change-coupling ----------------------------------------------------
coupling() {
  if [ ! -s "$work/testfiles" ]; then mark "change-coupling" "not run" "no test files matched"; return; fi
  git -C "$repo" log -n "$history" --no-merges --format='@%H%x09%s' --name-only 2>/dev/null |
    TEST_RE="$test_re" awk -v minr="$min_refactors" -v ratio="$ratio" '
      BEGIN { re = ENVIRON["TEST_RE"] }
      function flush() {
        if (c != "" && isref && nontest > 0) { total++; for (f in seen) hit[f]++ }
        delete seen; nontest = 0
      }
      /^@/ { flush(); c = $0; s = tolower($0); sub(/^[^\t]*\t/, "", s)
             isref = (s ~ /^(refactor|style|perf|chore)(\([^)]*\))?!?:/ || s ~ /(refactor|rename|restructur|extract |move )/); next }
      NF == 0 { next }
      { if ($0 ~ re) seen[$0] = 1; else nontest++ }
      END { flush()
        if (total < minr) { print "SKIP\t" total; exit }
        for (f in hit) if (hit[f] / total >= ratio) printf "%s\t%d\t%d\n", f, hit[f], total
        print "TOTAL\t" total }' > "$work/coupling.out"
  if grep -q '^SKIP' "$work/coupling.out"; then
    mark "change-coupling" "not run" "only $(cut -f2 "$work/coupling.out") refactor commits in last $history (need $min_refactors)"
    return
  fi
  total="$(awk -F'\t' '$1=="TOTAL"{print $2}' "$work/coupling.out")"
  mark "change-coupling" "ran" "$total refactor commits in last $history; file-level (git cannot attribute a single test)"
  awk -F'\t' '$1!="TOTAL"' "$work/coupling.out" | while IFS=$'\t' read -r f n t; do
    emit "$f" "change-coupling" 2 "changed in $n of $t refactor commits (that touched production code); likely asserts implementation, not behavior"
  done
}

# ---- signal: duplicate assertions -----------------------------------------------
duplicates() {
  if [ ! -s "$work/testfiles" ]; then mark "duplicate-assertions" "not run" "no test files matched"; return; fi
  while IFS= read -r f; do
    grep -nE '(assert|expect|should|verify)[A-Za-z_.]*[ (]' "$repo/$f" 2>/dev/null | sed "s|^|$f:|" || true
  done < "$work/testfiles" |
    awk -F: -v minc="$dup_min" '
      { file = $1; line = $2; $1 = ""; $2 = ""; t = $0; gsub(/^[ \t:]+|[ \t]+$/, "", t); gsub(/[ \t]+/, " ", t)
        if (length(t) < 25) next
        n[t]++; where[t] = where[t] (n[t] > 1 ? ", " : "") file ":" line; fl[t] = fl[t] "\n" file }
      END { for (t in n) if (n[t] >= minc) {
              m = split(fl[t], a, "\n"); delete u
              for (i = 2; i <= m; i++) if (!(a[i] in u)) { u[a[i]] = 1
                printf "%s\t%d\t%s\t%s\n", a[i], n[t], t, where[t] } } }' > "$work/dups.out"
  mark "duplicate-assertions" "ran" "same assertion line in >= $dup_min places; line-text heuristic, no parsing"
  while IFS=$'\t' read -r f n text where; do
    emit "$f" "duplicate-assertions" 1 "assertion repeated $n times repo-wide: \`${text}\` (at ${where})"
  done < "$work/dups.out"
}

# ---- signal: flaky and slow (JUnit from --test-cmd) -------------------------------
junit_rows() { # run-number, xml file -> id<TAB>file<TAB>seconds<TAB>P|F
  sed 's/</\n</g' "$2" | awk -v run="$1" '
    function attr(s, k,   i, r) { i = index(s, " " k "=\""); if (!i) return ""
      r = substr(s, i + length(k) + 3); return substr(r, 1, index(r, "\"") - 1) }
    function done_() { if (id != "") printf "%s\t%s\t%s\t%s\n", id, file, secs, (bad ? "F" : "P"); id = "" }
    /^<testcase/ { done_(); cls = attr($0, "classname"); nm = attr($0, "name"); file = attr($0, "file")
      if (file == "") file = cls; id = cls "::" nm; secs = attr($0, "time"); bad = 0
      if ($0 ~ /\/>$/) done_(); next }
    /^<(failure|error)/ { bad = 1; next }
    /^<\/testcase/ { done_() }
    END { done_() }'
}
flaky_slow() {
  if [ -z "$test_cmd" ]; then
    mark "flaky" "not run" "no --test-cmd"; mark "slow" "not run" "no --test-cmd"; return
  fi
  make_copy; : > "$work/runs.tsv"; local i got=0
  for ((i = 1; i <= runs; i++)); do
    rm -f "$work/junit.xml"
    (cd "$work/copy" && MITHRIL_JUNIT_OUT="$work/junit.xml" bash -c "$test_cmd" >/dev/null 2>&1) || true
    if [ -s "$work/junit.xml" ]; then junit_rows "$i" "$work/junit.xml" >> "$work/runs.tsv"; got=$((got + 1)); fi
  done
  if [ "$got" -eq 0 ]; then
    mark "flaky" "not run" "--test-cmd wrote no JUnit XML to \$MITHRIL_JUNIT_OUT"
    mark "slow" "not run" "--test-cmd wrote no JUnit XML to \$MITHRIL_JUNIT_OUT"; return
  fi
  if [ "$got" -ge 2 ]; then mark "flaky" "ran" "$got runs compared"
  else mark "flaky" "not run" "only $got run produced JUnit XML (need 2)"; fi
  mark "slow" "ran" "mean seconds per test over $got run(s), threshold ${slow_s}s"
  awk -F'\t' -v slow="$slow_s" -v runsok="$got" '
    { p = $1; f[p] = $2; t[p] += $3; c[p]++; if ($4 == "F") fail[p]++; else pass[p]++ }
    END { for (p in c) {
      if (runsok >= 2 && fail[p] > 0 && pass[p] > 0) printf "%s\tflaky\t3\tfailed %d of %d runs, passed the rest (%s)\n", f[p], fail[p], c[p], p
      if (t[p] / c[p] >= slow) printf "%s\tslow\t1\tmean %.2fs (%s)\n", f[p], t[p] / c[p], p } }' "$work/runs.tsv" >> "$sig"
}

# ---- signal: mutation (Stryker-format report) + baseline score ----------------------
mutation_score=""
mutation() {
  if [ "$run_mut" -eq 1 ] && [ -z "$mut_report" ]; then
    if { ls "$repo"/stryker.conf.* >/dev/null 2>&1 || grep -q '"stryker"' "$repo/package.json" 2>/dev/null; } &&
      [ -x "$repo/node_modules/.bin/stryker" ]; then
      make_copy
      (cd "$work/copy" && node_modules/.bin/stryker run --reporters json >/dev/null 2>&1) || true
      [ -s "$work/copy/reports/mutation/mutation.json" ] && mut_report="$work/copy/reports/mutation/mutation.json"
    fi
    [ -n "$mut_report" ] || { mark "mutation" "not run" "--run-mutation: no Stryker config + node_modules/.bin/stryker, or the run produced no report"; return; }
  fi
  if [ -z "$mut_report" ]; then mark "mutation" "not run" "no --mutation-report and no --run-mutation (opt-in, as in skills/gates.md)"; return; fi
  command -v jq >/dev/null 2>&1 || { mark "mutation" "not run" "jq not installed (brew install jq)"; return; }
  if ! { [ -r "$mut_report" ] && jq -e '.files' "$mut_report" >/dev/null 2>&1; }; then mark "mutation" "not run" "$mut_report is not a Stryker mutation report"; return; fi
  mutation_score="$(jq -r '[.files[]?.mutants[]?.status] | (map(select(. == "Killed" or . == "Timeout")) | length) as $k
    | (map(select(. == "Killed" or . == "Timeout" or . == "Survived" or . == "NoCoverage")) | length) as $t
    | if $t == 0 then "" else (($k * 1000 / $t | round) / 10 | tostring) end' "$mut_report")"
  local killed_total
  killed_total="$(jq '[.files[]?.mutants[]?.killedBy[]?] | length' "$mut_report")"
  if [ "$killed_total" -eq 0 ]; then
    mark "mutation" "ran" "score recorded; no mutant was killed by any test, so per-test attribution would be noise and is skipped"; return
  fi
  mark "mutation" "ran" "per-test: covers mutants but kills none (killedBy in the report)"
  jq -r '([.files[]?.mutants[]?.killedBy[]?] | map({(.): true}) | add // {}) as $k
    | ([.files[]?.mutants[]?.coveredBy[]?] | group_by(.) | map({(.[0]): length}) | add // {}) as $cov
    | .testFiles // {} | to_entries[] | .key as $f | .value.tests[]?
    | select(($k[.id] | not) and (($cov[.id] // 0) > 0))
    | [$f, "mutation", "3", "covers \($cov[.id]) mutants, kills none: \(.name)"] | @tsv' "$mut_report" >> "$sig"
}

# ---- baseline coverage ----------------------------------------------------------
coverage=""
baseline_coverage() {
  if [ -n "$cov_pct" ]; then coverage="$cov_pct"; return; fi
  [ -n "$cov_cmd" ] || return 0
  make_copy
  local v; v="$( (cd "$work/copy" && bash -c "$cov_cmd" 2>/dev/null) | tail -1 | tr -d '% ')" || true
  case "$v" in '' | *[!0-9.]*) ;; *) coverage="$v" ;; esac
}

coupling; duplicates; flaky_slow; mutation; baseline_coverage

after_state="$(git -C "$repo" rev-parse HEAD 2>/dev/null)$(git -C "$repo" status --porcelain=v1 --untracked-files=all | cksum)"
touched="$(find "$repo" -path "$repo/.git" -prune -o -newer "$work/start-marker" -print 2>/dev/null | head -3 | tr '\n' ' ')"
repo_clean_note="no file in the target repo (ignored files included, .git excluded) was modified during this run; HEAD and status unchanged"
if [ "$before_state" != "$after_state" ] || [ -n "$touched" ]; then
  repo_clean_note="WARNING: the target repo was modified during the run (${touched:-git state changed}); investigate"
fi

# ---- compare with an earlier report ----------------------------------------------
num_of() { sed -n "s/.*\"$2\": *\([0-9.]*\).*/\1/p" "$1" | head -1; }
compare_lines=""
if [ -n "$prev" ]; then
  [ -r "$prev" ] || die "cannot read --compare file $prev"
  for pair in "coverage_pct:$coverage" "mutation_score_pct:$mutation_score"; do
    k="${pair%%:*}"; now="${pair#*:}"; was="$(num_of "$prev" "$k")"
    if [ -z "$was" ]; then v="CANNOT PROVE (not measured in the earlier report)"
    elif [ -z "$now" ]; then v="CANNOT PROVE (not measured in this run)"
    elif awk -v a="$now" -v b="$was" 'BEGIN { exit !(a + 0 < b + 0) }'; then v="DROPPED ($was -> $now)"
    else v="no drop ($was -> $now)"; fi
    compare_lines="$compare_lines$k: $v"$'\n'
  done
fi

# ---- rank and write the report ----------------------------------------------------
head_sha="$(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo none)"
now_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
awk -F'\t' '
  { s[$1] += $3; r[$1] = r[$1] (r[$1] == "" ? "" : " @@ ") $2 "::" $4; f[$1] = f[$1] "," $2 }
  END { for (k in s) {
    a = "review"
    if (f[k] ~ /flaky/) a = "rewrite: remove the non-determinism (quarantine is triage, not a destination)"
    else if (f[k] ~ /change-coupling/ && f[k] !~ /mutation/) a = "rewrite: assert behavior at the public boundary"
    else if (f[k] ~ /mutation/) a = "cull candidate: confirm another test owns the contract first"
    printf "%d\t%s\t%s\t%s\n", s[k], k, a, r[k] } }' "$sig" | sort -t$'\t' -k1,1nr -k2,2 > "$work/ranked.tsv"

esc() { sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }
jnum() { [ -n "$1" ] && printf '%s' "$1" || printf 'null'; }
{
  printf '{\n  "generated": "%s",\n  "repo_head": "%s",\n  "report_only": true,\n' "$now_utc" "$head_sha"
  printf '  "baseline": {\n    "coverage_pct": %s,\n    "mutation_score_pct": %s\n  },\n' "$(jnum "$coverage")" "$(jnum "$mutation_score")"
  printf '  "signals": [\n'
  awk -F'\t' 'function e(s){gsub(/\\/,"\\\\",s);gsub(/"/,"\\\"",s);return s}
    {printf "%s    {\"signal\": \"%s\", \"status\": \"%s\", \"detail\": \"%s\"}", (NR>1?",\n":""), $1, $2, e($3)} END{print ""}' "$status_file"
  printf '  ],\n  "candidates": [\n'
  awk -F'\t' 'function e(s){gsub(/\\/,"\\\\",s);gsub(/"/,"\\\"",s);return s}
    { printf "%s    {\"rank\": %d, \"file\": \"%s\", \"score\": %d, \"action\": \"%s\", \"reasons\": [", (NR>1?",\n":""), NR, e($2), $1, e($3)
      n = split($4, rs, " @@ ")
      for (i = 1; i <= n; i++) { p = index(rs[i], "::")
        printf "%s{\"signal\": \"%s\", \"evidence\": \"%s\"}", (i>1?", ":""), substr(rs[i], 1, p-1), e(substr(rs[i], p+2)) }
      printf "]}" } END { print "" }' "$work/ranked.tsv"
  printf '  ],\n  "compare": ['
  if [ -n "$compare_lines" ]; then printf '%s' "$compare_lines" | esc | awk 'NF{printf "%s\"%s\"", (c++?", ":""), $0}'; fi
  printf '],\n  "repo_check": "%s"\n}\n' "$repo_clean_note"
} > "$out/report.json"

{
  echo "# Test cull report (report only)"
  echo
  echo "Repo head \`$head_sha\`, generated $now_utc. Nothing here has been deleted or edited. Each deletion needs the owner's approval."
  echo
  echo "## Baseline (record this before any approved deletion)"
  echo
  if [ -n "$coverage" ]; then echo "- Coverage: ${coverage}%"
  else echo "- Coverage: not measured (pass --coverage-pct or --coverage-cmd; without it a later run cannot prove coverage held)"; fi
  if [ -n "$mutation_score" ]; then echo "- Mutation score: ${mutation_score}%"
  else echo "- Mutation score: not measured (pass --mutation-report or --run-mutation; without it a later run cannot prove the score held)"; fi
  echo "- After deletions, rerun with \`--compare report.json\`; the cull is only sound if neither number drops."
  if [ -n "$compare_lines" ]; then echo; echo "## Comparison with earlier report"; echo; printf '%s' "$compare_lines" | sed 's/^/- /'; fi
  echo
  echo "## Signals"
  echo
  echo "| Signal | Status | Detail |"; echo "|---|---|---|"
  awk -F'\t' '{printf "| %s | %s | %s |\n", $1, $2, $3}' "$status_file"
  echo
  echo "## Candidates (ranked by weighted evidence)"
  echo
  if [ -s "$work/ranked.tsv" ]; then
    echo "| # | File | Score | Suggested action | Evidence |"; echo "|---|---|---|---|---|"
    awk -F'\t' '{ n = split($4, rs, " @@ "); ev = ""
      for (i = 1; i <= n; i++) { p = index(rs[i], "::"); ev = ev (i>1 ? "<br>" : "") "**" substr(rs[i], 1, p-1) "**: " substr(rs[i], p+2) }
      gsub(/\|/, "\\|", ev); printf "| %d | `%s` | %d | %s | %s |\n", NR, $2, $1, $3, ev }' "$work/ranked.tsv"
  else
    echo "No candidates from the signals that ran."
  fi
  echo
  echo "## Before approving a deletion"
  echo
  echo "- Retention bar (\`skills/test-quality.md\`): never delete a test that independently guards a public API, protocol, config, migration, storage, security or release contract. Tighten it instead. Slow or static is not a reason to delete."
  echo "- A flag is evidence, not a verdict. Weights: mutation 3, flaky 3, change-coupling 2, duplicate 1, slow 1."
  echo "- $repo_clean_note."
} > "$out/report.md"

echo "wrote $out/report.md and $out/report.json ($(wc -l < "$work/ranked.tsv" | tr -d ' ') candidates)"
