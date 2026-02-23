---
name: ask
description: Answer a question with web-search fact-checking and sources
user-invocable: true
allowed-tools: WebSearch, WebFetch, Read
---

# Ask

Answer the following question accurately and concisely.

**Rules:**
1. If the subject is not about local files, always perform at least one `WebSearch` to fact-check before answering. Do not rely solely on training data.
2. If web results contradict your initial assumptions, explicitly flag the discrepancy.
3. End your response with a `Sources:` section listing relevant URLs as markdown links.
4. Be direct. No filler.

## Question

$ARGUMENTS
