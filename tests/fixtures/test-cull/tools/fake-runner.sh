#!/usr/bin/env bash
# Stand-in for a real runner: writes one-line JUnit XML to $MITHRIL_JUNIT_OUT.
# test_flaky fails on the second run only; test_slow takes 2.5s; the rest pass fast.
set -eu
counter="$(dirname "$MITHRIL_JUNIT_OUT")/run-count"
n=$(( $(cat "$counter" 2>/dev/null || echo 0) + 1 )); echo "$n" > "$counter"
flaky_body=""; [ "$n" -eq 2 ] && flaky_body='<failure message="timing"/>'
printf '%s' '<?xml version="1.0"?><testsuites><testsuite name="fx">' \
  '<testcase classname="tests.test_good" file="tests/test_good.py" name="test_add_returns_sum" time="0.01"/>' \
  "<testcase classname=\"tests.test_flaky\" file=\"tests/test_flaky.py\" name=\"test_flaky_timing\" time=\"0.02\">${flaky_body}</testcase>" \
  '<testcase classname="tests.test_slow" file="tests/test_slow.py" name="test_slow_report" time="2.5"/>' \
  '</testsuite></testsuites>' > "$MITHRIL_JUNIT_OUT"
