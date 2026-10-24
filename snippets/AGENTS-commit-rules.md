## Commit Message Format

- First line: short summary with scope prefix, capitalized (e.g., `fix: Wrap registration in atomic transaction`)
- Optional detailed body after a blank line
- Scopes: `fix`, `feat`, `docs`, `refactor`, `test`, `chore`, etc.
- No `Co-Authored-By` trailer

This is enforced by a git `commit-msg` hook. Run `pre-commit install -t pre-commit -t commit-msg` once per clone.
