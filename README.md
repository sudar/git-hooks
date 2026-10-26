# git-hooks

Shared git hooks for [pre-commit](https://pre-commit.com). **You need pre-commit installed to use this repo.** Pre-commit clones this repo at a pinned tag, installs the git hooks, and runs them. Nothing runs without it.

Because they are git hooks, they work with every tool: Claude Code, Codex, OpenCode, Copilot, Cursor, and a human at the terminal.

## Dependencies

| Dependency | Needed for | Install |
|---|---|---|
| [pre-commit](https://pre-commit.com) | Everything. It installs and runs the hooks. | `brew install pre-commit` or `pip install pre-commit` |
| [git](https://git-scm.com) | Everything. | Usually already installed. |
| [gitleaks](https://github.com/gitleaks/gitleaks) | `gitleaks-staged` only. Pre-commit does not install it. It must be on `PATH`. | `brew install gitleaks` |
| bash, grep, awk | `check-commit-msg`. | Already present on macOS and Linux. On Windows, use Git Bash or WSL. |
| [jq](https://jqlang.org) | The optional Claude Code check in `claude/` only. If `jq` is missing, that check skips itself. | `brew install jq` |

A project that uses only `check-commit-msg` does not need gitleaks. Pre-commit needs network access on first run, to clone this repo.

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
  - repo: https://github.com/sudar/git-hooks   # or a local path while testing
    rev: v1.0.1
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
