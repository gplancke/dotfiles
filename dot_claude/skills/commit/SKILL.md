---
name: commit
description: Split uncommitted changes into semantically coherent commits with conventional-style messages
user-invocable: true
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git restore:*), Bash(git commit:*), Bash(git ls-files:*)
---

# /commit — Smart Semantic Commit Splitter

## Context (auto-injected)

```
$ git status --short
```
!`git status --short`

```
$ git diff --cached --stat
```
!`git diff --cached --stat`

```
$ git diff --stat
```
!`git diff --stat`

```
$ git ls-files --others --exclude-standard
```
!`git ls-files --others --exclude-standard`

```
$ git log --oneline -8
```
!`git log --oneline -8`

```
$ git branch --show-current
```
!`git branch --show-current`

**User hints:** $ARGUMENTS

---

## Instructions

Follow these steps exactly.

### 1. Guard Rails

Abort with a clear message if any of these are true:
- Not inside a git repository
- Working tree is clean (nothing to commit) — say "Nothing to commit — working tree clean."
- Merge conflicts detected (`UU` in status) — say "Merge conflicts detected. Resolve them first."

### 2. Read Full Diff

Run `git diff HEAD` to get the complete diff of all tracked changes. For untracked files, read their contents with `git diff --no-index /dev/null <file>` or just note them. Note any binary files separately (they won't have readable diffs).

### 3. Classify Changes into Semantic Groups

Analyze every changed/added/deleted file and assign it to exactly ONE group using this priority table:

| Priority | Type | Scope hint | Matches |
|----------|------|-----------|---------|
| 1 | `build` / `chore(deps)` | — | package.json, lockfiles (package-lock, yarn.lock, pnpm-lock, bun.lockb, Cargo.lock, go.sum), build configs (webpack, vite, tsconfig, Makefile, Dockerfile, CI yaml) |
| 2 | `test` | module name | Files in `__tests__/`, `test/`, `tests/`, `spec/`, or matching `*.test.*`, `*.spec.*` |
| 3 | `docs` | — | `*.md`, `README*`, `CHANGELOG*`, `LICENSE`, `docs/` directory |
| 4 | `style` | — | Formatting-only changes (whitespace, semicolons, quotes) with zero logic change |
| 5 | `refactor` | module name | Renames, moves, extractions — no new behavior, no bug fix |
| 6 | `fix` | module name | Bug corrections, error handling fixes |
| 7 | `feat` | module name | New capabilities, new files that add functionality |
| 8 | `chore` | — | Everything else (config, gitignore, editor settings, etc.) |

**Rules:**
- If a file contains changes spanning multiple concerns, assign the whole file to the **dominant** concern. Mention the secondary concern in the commit body.
- If there is only one logical change across all files, produce a single commit — do NOT force-split.
- Binary files go into a trailing `chore` commit unless they clearly belong to another group.

### 4. Determine Commit Order

Order the groups for committing:

`build`/`chore(deps)` → `refactor` → `fix` → `feat` → `test` → `docs` → `style` → `chore`

Drop any groups that have no files.

### 5. Present Plan and Ask for Confirmation

Display a numbered list like:

```
Commit plan (N commits):

  1. feat(auth): add login form component
     - src/components/LoginForm.svelte (new)
     - src/lib/auth.ts (modified)

  2. test(auth): add login form tests
     - src/components/LoginForm.test.ts (new)

  3. docs: update README with auth setup
     - README.md (modified)
```

Then ask the user to confirm, modify, or cancel.

**Exception:** If `$ARGUMENTS` contains `--yes` or `-y`, skip confirmation and execute immediately.

### 6. Execute Commits Sequentially

For each group in order:

1. `git restore --staged .` — clear staging area
2. `git add <file1> <file2> ...` — stage only this group's files (use `--force` for untracked files if needed, but prefer plain `git add`)
3. Verify with `git diff --cached --stat` that only the intended files are staged
4. Commit using a HEREDOC:
   ```
   git commit -m "$(cat <<'EOF'
   <type>(<scope>): <short description>

   <optional body — only if "why" is non-obvious>

   Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```

### 7. Edge Case Handling

- **Pre-commit hook failure:** Stop immediately. Show the error. Ask the user how to proceed (fix, skip hook, or abort remaining commits).
- **Partial staging issues:** If `git add` fails for a file, report it and continue with the rest of the group.
- **Single logical change:** If all changes are one cohesive unit, make ONE commit. Don't artificially split.
- **Already-staged changes:** Respect them — include staged files in the analysis and classification.

### 8. Finish

After all commits, run `git log --oneline -<N>` (where N = number of commits just created) to show the result.

## Commit Message Format

Follow **Conventional Commits**:
- Format: `<type>(<scope>): <short description>`
- Scope is optional but preferred when a clear module/component is affected
- Subject line: imperative mood ("add", not "added"), ≤ 72 characters
- Body: only when the "why" is non-obvious; wrap at 72 characters
- Always end with the `Co-Authored-By` trailer
