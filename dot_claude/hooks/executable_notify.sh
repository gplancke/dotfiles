#!/usr/bin/env bash
# Read hook input from stdin
input=$(cat)
title=$(echo "$input" | jq -r '.title // "Claude Code"')
message=$(echo "$input" | jq -r '.message // "Needs your attention"')

if command -v terminal-notifier &>/dev/null; then
  terminal-notifier -title "$title" -message "$message" -sound Glass
else
  osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
fi
