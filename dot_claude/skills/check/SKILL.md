---
name: check
description: Check current work for security issues, inefficiencies, and bad patterns
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
---

# Review

Review the current working state of this project and produce a structured report.

## Steps

1. Run `git status` and `git diff` to understand recent changes. If no uncommitted changes, review the last commit.
2. Detect available tooling (linter, type-checker) from config files and `package.json`.
3. Run detected linter and type-checker, capture output.
4. Scan changed files for OWASP top 10 security issues.
5. Check for code smells: deep nesting, `let` where `const` suffices, dead code, missing error handling at boundaries, duplication.
6. Check adherence to `CLAUDE.md` conventions if the file exists.

## Output format

```
## Review Report

### Summary
[1-2 sentence overview]

### Critical (must fix)
- [ ] [file:line] Description — severity: critical

### Warnings (should fix)
- [ ] [file:line] Description — severity: warning

### Suggestions (nice to have)
- [ ] [file:line] Description — severity: info

### Linter / Type-checker output
[Raw output or "All clear"]

### Security
[Findings or "No issues found"]
```

If everything is clean, say so briefly.
