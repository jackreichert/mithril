#!/usr/bin/env bash
# Plugin hook entry. Claude Code runs this; it executes scripts/done-check.sh.
# The review prompt is not the verdict.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$here/done-verdict.py"
