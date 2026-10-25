#!/usr/bin/env bash
set -uo pipefail
# Runs the same command as the gitleaks-staged hook against a throwaway repo.
# The fake secret is assembled at runtime so this file never contains one.
command -v gitleaks >/dev/null || { echo "skip: gitleaks not installed"; exit 0; }

CMD=(gitleaks git --pre-commit --redact --staged --no-color)
D="$(mktemp -d)"; trap 'rm -rf "$D"' EXIT
cd "$D" && git init -q
fail=0

echo "hello world" > ok.txt && git add ok.txt
"${CMD[@]}" >/dev/null 2>&1 || { echo "FAIL: clean file was rejected"; fail=1; }

git reset -q
tok="ghp_$(printf 'aB3dE5fG7hJ9kL1mN3pQ5rS7tU9vW1xY3zA5')"
echo "token = \"$tok\"" > leak.txt && git add leak.txt
"${CMD[@]}" >/dev/null 2>&1 && { echo "FAIL: secret was not detected"; fail=1; }

[[ $fail -eq 0 ]] && echo "all passed"; exit $fail
