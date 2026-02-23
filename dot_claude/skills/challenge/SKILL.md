---
name: challenge
description: Constructively criticize an assessment or opinion, searching the web for state-of-the-art evidence when warranted
user-invocable: true
allowed-tools: WebSearch, WebFetch
---

# Challenge

Constructively criticize the following assessment or opinion.

## Steps

1. Restate the core claim in one sentence to confirm understanding.
2. Identify the underlying assumptions and premises.
3. Determine whether web research would strengthen the critique (search when the claim involves factual, scientific, technical, or recent/evolving topics; skip for pure subjective preferences).
4. If searching, use `WebSearch` and `WebFetch` to find current evidence, counterarguments, expert consensus, and state-of-the-art research.
5. Produce the structured critique below.

## Rules

- Be direct, fair, and constructive. No strawmanning.
- Acknowledge what is strong before pointing out what is weak.
- Cite specific evidence or reasoning for each weakness — no vague hand-waving.
- If web search was performed, end with a `Sources:` section listing relevant URLs as markdown links.

## Output format

```
## Challenge

### Claim
[One-sentence restatement]

### Strengths
- [What holds up and why]

### Weaknesses
- [Logical gaps, unsupported assumptions, counterevidence]

### State of the Art
[What current research or expert consensus says — omit this section if no web search was performed]

### Verdict
[Overall assessment with nuance — not a binary right/wrong]
```

## Assessment

$ARGUMENTS
