# git-hooks

Shared git hooks for [pre-commit](https://pre-commit.com). Because they are git hooks, they work with every tool: Claude Code, Codex, OpenCode, Copilot, Cursor, and a human at the terminal.

## Hooks

| id | Stage | What it does |
|---|---|---|
| `check-commit-msg` | `commit-msg` | Requires a `scope: Capitalized summary` first line. Rejects `Co-Authored-By` trailers. |
| `gitleaks-staged` | `pre-commit` | Scans the staged diff for hardcoded secrets. Needs `gitleaks` on `PATH` (`brew install gitleaks`). |

Lint hooks are not shared yet.

## Use it in a project

Add this to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/<you>/git-hooks   # or a local path while testing
    rev: v1.0.0
    hooks:
      - id: check-commit-msg
        # args: [--allow-co-authored-by, --scopes, "fix,feat,docs,refactor,test,chore"]
      - id: gitleaks-staged
```

Then run once per clone:

```bash
pre-commit install -t pre-commit -t commit-msg
```

## `check-commit-msg` options

| Arg | Effect |
|---|---|
| `--allow-co-authored-by` | Permit `Co-Authored-By` trailers (default: rejected). |
| `--scopes a,b,c` | Only allow these scopes. |

Merge, revert, `fixup!` and `squash!` messages are skipped.

## Tell the AI tools the commit rule

Paste `snippets/AGENTS-commit-rules.md` into the project's `AGENTS.md`. Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists, so if the project has a `CLAUDE.md`, add `@AGENTS.md` as its first line.

## Optional: Claude Code fast check

`claude/check-commit.sh` denies a `git commit` that contains a trailer, before git runs. Copy it to `.claude/hooks/` in the project and merge `claude/settings-snippet.json` into `.claude/settings.json`. The git hook is still the real enforcement.

## Gaps

Tools that commit through the GitHub API (web UI, some cloud agents) skip local hooks. Add a CI check on PR commit messages if you use them.

## Test

```bash
tests/test.sh
tests/test-gitleaks.sh
```
