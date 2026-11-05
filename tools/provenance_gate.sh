#!/usr/bin/env bash
# Provenance gate: every commit in BASE..HEAD needs a Ticket trailer, and every
# agent commit needs a session link (Agent-Session or Copilot's Agent-Logs-Url).
# Usage: provenance_gate.sh <base-ref> [head-ref]
set -uo pipefail
BASE="$1"; HEAD="${2:-HEAD}"
fail=0; n=0
for c in $(git rev-list "$BASE..$HEAD"); do
  n=$((n+1)); short=$(git rev-parse --short "$c"); subj=$(git show -s --format=%s "$c")
  t=$(git show -s --format='%(trailers:key=Ticket,valueonly)' "$c" | head -1)
  if [ -z "$t" ]; then echo "FAIL  $short  \"$subj\"  missing Ticket trailer"; fail=1; continue; fi
  if git show -s --format=%B "$c" | grep -qE '^(Agent-Tool:|Co-authored-by: Copilot)'; then
    s=$(git show -s --format='%(trailers:key=Agent-Session,valueonly)%(trailers:key=Agent-Logs-Url,valueonly)' "$c" | tr -d '\n')
    if [ -z "$s" ]; then echo "FAIL  $short  \"$subj\"  agent commit without session link"; fail=1; continue; fi
    echo "PASS  $short  \"$subj\"  Ticket=$t  Agent-Session=$s"
  else
    echo "PASS  $short  \"$subj\"  Ticket=$t  (human commit)"
  fi
done
[ $fail -eq 0 ] && echo "GATE  passed ($n commit(s))" || echo "GATE  failed"
exit $fail
