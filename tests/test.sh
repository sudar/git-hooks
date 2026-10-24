#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
HOOK=hooks/check-commit-msg.sh
fail=0
t() { # expected-exit "message" [hook args...]
  local want="$1" msg="$2"; shift 2
  local f; f="$(mktemp)"; printf '%s\n' "$msg" > "$f"
  "$HOOK" "$@" "$f" >/dev/null 2>&1; local got=$?
  rm -f "$f"
  if [[ $got -ne $want ]]; then echo "FAIL (want $want got $got): $msg [$*]"; fail=1; fi
}
t 0 "fix: Wrap registration in atomic transaction"
t 0 $'feat: Add thing\n\nBody text'
t 1 "Fix the thing"
t 1 "fix: lowercase summary"
t 1 $'fix: Ok\n\nCo-Authored-By: Bot <b@x.com>'
t 0 $'fix: Ok\n\nCo-Authored-By: Bot <b@x.com>' --allow-co-authored-by
t 0 $'fix: Ok\n\nMentions Co-Authored-By in prose'
t 0 'Merge branch main'
t 0 'Revert "feat: Thing"'
t 0 "fixup! fix: Thing"
t 0 $'# comment\nfix: Ok' 
t 0 "fix: Ok" --scopes fix,feat
t 1 "docs: Ok" --scopes fix,feat
[[ $fail -eq 0 ]] && echo "all passed"; exit $fail
