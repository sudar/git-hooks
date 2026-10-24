#!/usr/bin/env bash
set -euo pipefail

# Enforces a `scope: Capitalized summary` first line, and (by default)
# rejects a `Co-Authored-By` trailer. Runs as a git `commit-msg` hook, so it
# applies to every committer and every tool, not just one AI assistant.
#
# Usage (pre-commit appends the message file after any args):
#   check-commit-msg.sh [--allow-co-authored-by] [--scopes a,b,c] <commit-msg-file>

ALLOW_TRAILER=0
SCOPES=""
MSG_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --allow-co-authored-by) ALLOW_TRAILER=1; shift ;;
    --scopes) SCOPES="${2:?--scopes needs a comma-separated list}"; shift 2 ;;
    *) MSG_FILE="$1"; shift ;;
  esac
done

: "${MSG_FILE:?usage: check-commit-msg.sh [options] <commit-msg-file>}"

# Drop git's own comment lines (present for interactive commits).
BODY="$(grep -v '^#' "$MSG_FILE" || true)"
FIRST_LINE="$(printf '%s\n' "$BODY" | awk 'NF{print; exit}')"

# Git generates these itself; they never follow the scope convention.
if [[ "$FIRST_LINE" =~ ^(Merge|Revert\ \"|fixup!|squash!) ]]; then
  exit 0
fi

if [[ "$ALLOW_TRAILER" -eq 0 ]] && printf '%s\n' "$BODY" | grep -qiE '^[[:space:]]*Co-Authored-By:'; then
  echo "commit-msg: rejected -- no Co-Authored-By trailer allowed in this project" >&2
  exit 1
fi

if [[ ! "$FIRST_LINE" =~ ^[a-z][a-z-]*:\ [A-Z] ]]; then
  echo "commit-msg: rejected -- first line must be 'scope: Capitalized summary' (e.g. 'fix: Wrap registration in atomic transaction'); got: ${FIRST_LINE}" >&2
  exit 1
fi

if [[ -n "$SCOPES" ]]; then
  SCOPE="${FIRST_LINE%%:*}"
  if [[ ",${SCOPES}," != *",${SCOPE},"* ]]; then
    echo "commit-msg: rejected -- scope '${SCOPE}' is not one of: ${SCOPES}" >&2
    exit 1
  fi
fi

exit 0
