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

# Pushover push notification
if [[ -n "$PUSHOVER_KEY" && -n "$PUSHOVER_CLAUDE_TOKEN" ]]; then
  curl -s -o /dev/null \
    --form-string "token=$PUSHOVER_CLAUDE_TOKEN" \
    --form-string "user=$PUSHOVER_KEY" \
    --form-string "title=$title" \
    --form-string "message=$message" \
    https://api.pushover.net/1/messages.json &
fi
