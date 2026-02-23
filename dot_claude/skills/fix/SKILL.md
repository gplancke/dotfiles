---
name: fix
description: Debug thoroughly by tracing code paths, searching the web for known issues, diagnosing the root cause, planning a fix, and asking about next steps
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash, WebSearch, WebFetch, Task, AskUserQuestion
---

# /fix — Thorough Debugging Skill

You are a systematic debugger. Given `$ARGUMENTS` containing error messages, stack traces, symptoms, or a description of a bug, follow this workflow strictly.

## 1. Parse the input

Extract from `$ARGUMENTS`:
- Error messages and error codes
- Stack traces (file paths, line numbers, function names)
- Symptoms described in plain language
- Any file paths or identifiers mentioned

If the input is too vague to act on, use `AskUserQuestion` to clarify before proceeding.

## 2. Trace the code path

Use `Glob`, `Grep`, and `Read` to follow the execution path:
- Start at the error origin (file + line from the stack trace, or search for the error message in code).
- Trace upstream through callers and downstream through callees.
- Identify the exact code that produces the error or misbehavior.
- Read surrounding context (types, imports, related functions) to understand intent.

Use the `Task` tool with `subagent_type=Explore` for broad searches if the initial trace doesn't pinpoint the issue.

## 3. Gather context

- Run `git log --oneline -20 -- <affected_files>` to check for recent changes near the fault area.
- Run `git diff HEAD~5 -- <affected_files>` if recent commits look relevant.
- Read config files, dependency manifests (package.json, Cargo.toml, etc.), and lock files for version info.
- Read related test files to understand expected behavior.

## 4. Search the web

Use `WebSearch` to look up:
- The exact error message (in quotes).
- The error message combined with the relevant library/framework name and version.
- Known issues in the library's issue tracker.

Use `WebFetch` to read the most promising results (Stack Overflow answers, GitHub issues, docs).

Collect URLs for all sources you reference.

## 5. Diagnose

Synthesize all findings into a root cause analysis:
- List possible causes ranked by likelihood.
- For each cause, cite the evidence (code location, git history, web source).
- Clearly state which cause you believe is most likely and why.

## 6. Plan the fix

Propose concrete code changes:
- Specify exact file paths and line numbers.
- Show the before/after for each change.
- Note any side effects, risks, or additional tests needed.
- If there are multiple viable fixes, list them with trade-offs.

## 7. Ask the user

Present the diagnosis and proposed fix clearly, then use `AskUserQuestion` with these options:
- **Apply the fix** — Proceed with the proposed changes.
- **Investigate further** — Dig deeper into a specific area.
- **Try an alternative approach** — Use a different fix strategy.

Do NOT make any code changes until the user approves.

## Output format

Structure your response with these headers:
- **Error Summary** — One-line description of the bug.
- **Code Trace** — Key locations in the code path.
- **Root Cause** — Most likely explanation with evidence.
- **Proposed Fix** — Concrete changes to make.
- **Sources** — URLs from web search (if any).
