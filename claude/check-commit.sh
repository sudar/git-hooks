#!/usr/bin/env bash
set -euo pipefail

# Optional Claude Code PreToolUse fast-fail: denies a `git commit` command
# that contains a Co-Authored-By trailer line, before the commit is tried.
# The git hook (hooks/check-commit-msg.sh) is the real enforcement; this only
# saves a round trip. Skip it for projects that allow the trailer.

command -v jq >/dev/null 2>&1 || exit 0

COMMAND="$(cat | jq -r '.tool_input.command // empty')"

if printf '%s\n' "$COMMAND" | grep -qiE '^[[:space:]]*Co-Authored-By:'; then
  jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny",
    permissionDecisionReason: "Commits in this project never carry a Co-Authored-By trailer. Remove it and retry."}}'
  exit 2
fi
exit 0
