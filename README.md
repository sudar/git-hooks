# commit-hooks

A shared `commit-msg` hook for [pre-commit](https://pre-commit.com). It requires a `scope: Capitalized summary` first line and rejects `Co-Authored-By` trailers. Because it is a git hook, it works with every tool: Claude Code, Codex, OpenCode, Copilot, Cursor, and a human at the terminal.

## Use it in a project

Add this to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/<you>/commit-hooks   # or a local path while testing
    rev: v1.0.0
    hooks:
      - id: check-commit-msg
        # args: [--allow-co-authored-by, --scopes, "fix,feat,docs,refactor,test,chore"]
```

Then run once per clone:

```bash
pre-commit install -t commit-msg      # add -t pre-commit if you use other hooks
```

## Options

| Arg | Effect |
|---|---|
| `--allow-co-authored-by` | Permit `Co-Authored-By` trailers (default: rejected). |
| `--scopes a,b,c` | Only allow these scopes. |

Merge, revert, `fixup!` and `squash!` messages are skipped.

## Tell the AI tools the rule

Paste `snippets/AGENTS-commit-rules.md` into the project's `AGENTS.md`. Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists, so if the project has a `CLAUDE.md`, add `@AGENTS.md` as its first line.

## Optional: Claude Code fast check

`claude/check-commit.sh` denies a `git commit` that contains a trailer, before git runs. Copy it to `.claude/hooks/` in the project and merge `claude/settings-snippet.json` into `.claude/settings.json`. The git hook is still the real enforcement.

## Gaps

Tools that commit through the GitHub API (web UI, some cloud agents) skip local hooks. Add a CI check on PR commit messages if you use them.

## Test

`tests/test.sh`
