#!/usr/bin/env bash
#
# calibration/prompt-size.sh [--max-words N] <prompt> [<prompt> ...]
#
# Reports deterministic prompt-size metrics. The token count is an estimate;
# behavioral fidelity is measured separately with the seeded calibration cases.
set -euo pipefail

max_words=""
if [[ "${1:-}" == "--max-words" ]]; then
  max_words="${2:?usage: prompt-size.sh [--max-words N] <prompt> [<prompt> ...]}"
  shift 2
fi

(( $# > 0 )) || {
  echo "usage: prompt-size.sh [--max-words N] <prompt> [<prompt> ...]" >&2
  exit 2
}

command -v wc >/dev/null 2>&1 || {
  echo "required command not found: wc" >&2
  exit 2
}

printf 'prompt\tlines\twords\tbytes\test_tokens\n'
budget_failed=0

for prompt in "$@"; do
  [[ -f "$prompt" ]] || {
    echo "prompt not found: $prompt" >&2
    exit 2
  }

  read -r lines words bytes < <(wc -l -w -c < "$prompt")
  # Rough 4-byte/token trend estimate; behavioral calibration is authoritative.
  estimated_tokens=$(( (bytes + 3) / 4 ))
  printf '%s\t%d\t%d\t%d\t%d\n' \
    "$prompt" "$lines" "$words" "$bytes" "$estimated_tokens"

  if [[ -n "$max_words" && "$words" -gt "$max_words" ]]; then
    echo "word budget exceeded: $prompt ($words > $max_words)" >&2
    budget_failed=1
  fi
done

exit "$budget_failed"