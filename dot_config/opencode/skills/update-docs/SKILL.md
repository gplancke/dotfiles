---
name: update-docs
description: Deep scan codebase to update README.md, CLAUDE.md, TODO.md and docs/ wiki pages so they stay relevant
---

# /update-docs

Update existing documentation files to match the current state of the codebase.

**Target files:** `README.md`, `CLAUDE.md`, `TODO.md`, and all `docs/*.md` wiki pages

## Arguments

- `--create` — also create doc files that don't exist yet (default: skip missing files). This includes new `docs/*.md` pages for undocumented features.
- `--yes` / `-y` — skip confirmation and apply all updates immediately

## Workflow

### Step 1: Discover existing docs

Use Glob to find which target doc files exist:
- Root: `README.md`, `CLAUDE.md`, `TODO.md`
- Wiki: `docs/*.md` (all markdown files in the docs directory)

Note which files exist and which are missing.

If no target doc files exist and `--create` was NOT passed, inform the user and stop. If `--create` was passed, ask the user which files to create before proceeding.

### Step 2: Deep scan the codebase

Launch parallel exploration to gather codebase intelligence. Use at minimum these 3 concurrent approaches:

**Explore 1 — Structure & Stack:**
- Directory tree (top 2-3 levels)
- Languages, frameworks, key dependencies (from package.json, Cargo.toml, pyproject.toml, go.mod, etc.)
- Entry points, main modules, public API surface
- Build/test/deploy tooling from config files (Makefile, Dockerfile, CI configs, etc.)

**Explore 2 — Recent changes:**
- Run `git log --oneline -30` to get recent commits
- Run `git log --oneline --since="$(git log -1 --format=%ai -- README.md CLAUDE.md TODO.md docs/ 2>/dev/null | head -1)"` to find commits since docs were last touched
- Identify major changes: new features, renamed/removed files, architecture shifts, new dependencies

**Explore 3 — Code conventions & patterns:**
- Error handling patterns
- Testing approach (unit, integration, e2e — which frameworks)
- Code organization conventions (barrel files, module structure, naming)
- Key abstractions, shared types, core interfaces
- Environment/config management approach

### Step 3: Diff analysis

For **each existing doc file** (including all `docs/*.md` wiki pages), read its full content and compare against the scan results. Build a change list identifying:

- **Outdated sections** — references to removed/renamed files, deprecated APIs, old commands, wrong directory paths
- **Missing sections** — new features, new modules, changed architecture, new dependencies not documented
- **Stale TODOs** — items that have been completed (check git history) or abandoned
- **Inaccurate descriptions** — project descriptions, feature lists, or setup instructions that no longer match reality
- **Broken cross-links** — links between wiki pages that point to renamed/removed pages
- **Missing wiki pages** — significant features or subsystems that have no corresponding `docs/*.md` page (only flag these if `--create` was passed)

For `CLAUDE.md` specifically: focus on conventions, patterns, build/test/lint commands, and project-specific instructions. Do NOT turn it into code documentation.

### Step 4: Present changes

Show the user a structured summary of proposed updates, organized per file:

```
## README.md
- Update: project description (old → new)
- Add: section on new CLI commands
- Fix: installation instructions reference removed script

## docs/authentication.md
- Update: OAuth flow now includes SAML SSO option
- Fix: key files section references moved file

## TODO.md
- Remove: 3 completed items (feature X, bug Y, refactor Z)
- Add: 2 items found in code comments (FIXME/TODO grep)
```

**Ask the user for confirmation** before making any edits. Accept per-file approval (e.g. "skip CLAUDE.md, do the rest").

**Exception:** If the user's message contains `--yes` or `-y`, skip confirmation and apply all updates immediately.

### Step 5: Apply updates

For each approved file:

- Use **Edit** (not Write) to make surgical, in-place changes
- **Preserve the existing structure and style** of each document — match heading levels, list styles, tone
- Do NOT rewrite from scratch unless the file is fundamentally wrong
- For TODO.md: strike through or remove completed items, add new ones found in codebase (from FIXME/TODO/HACK comments)
- For new `docs/*.md` pages (when `--create` is passed): follow the existing wiki page conventions (title, sections, Key Files, See Also with cross-links)

### Step 6: Final summary

After applying changes, show a brief summary of what was updated across all files.

## Rules

1. **Never create files that don't exist** unless `--create` was explicitly passed
2. **Always ask before writing** — never silently edit docs (unless `--yes` is passed)
3. **Preserve doc style** — match the existing tone, formatting, heading structure
4. **Be conservative** — when unsure if something changed, leave it alone
5. **CLAUDE.md is special** — it contains instructions for AI agents, not code docs. Update conventions and commands, don't add code explanations
6. **Parallelize scanning** — use concurrent exploration for speed
7. **Git-aware** — use git history to determine what changed since docs were last updated
8. **Cross-link integrity** — check that all `docs/*.md` cross-links resolve to existing pages
