#!/bin/sh
# dim-bg.sh — compute a dimmed background color from the active tinted theme.
#
# Usage: dim-bg.sh <scheme-name>        e.g.  dim-bg.sh base16-eighties
#
# Called from ~/.tmux.conf to populate the @dim-bg user option, which the
# pane-focus-in/out hooks use to "tone down" inactive panes:
#     set-hook -g pane-focus-out "select-pane -P 'bg=#{@dim-bg}'"
#
# Prints a #rrggbb hex (leading '#' is REQUIRED so tmux reads it as an RGB
# color). Tune the darkness with DIM_FACTOR: 1.0 = unchanged, 0.0 = black.
set -eu

scheme="${1:-}"
factor="${DIM_FACTOR:-0.6}"   # brightness of inactive panes (0..1)

data="${XDG_DATA_HOME:-$HOME/.local/share}/tinted-theming/tinty"

# scheme name -> system/name  (base16-eighties -> base16/eighties)
system="${scheme%%-*}"
name="${scheme#*-}"
yaml="$data/repos/schemes/$system/$name.yaml"

# 1) preferred source: base00 (the background) from the scheme's yaml
bg=""
if [ -n "$scheme" ] && [ -f "$yaml" ]; then
  bg=$(sed -n 's/^[[:space:]]*base00:[[:space:]]*"\{0,1\}#\{0,1\}\([0-9A-Fa-f]\{6\}\).*/\1/p' "$yaml" | head -1)
fi

# 2) fallback: bg from the generated tinted-tmux status-style line
if [ -z "$bg" ] && [ -f "$data/tinted-tmux-colors-file.conf" ]; then
  bg=$(sed -n 's/.*status-style.*bg=#\([0-9A-Fa-f]\{6\}\).*/\1/p' "$data/tinted-tmux-colors-file.conf" | head -1)
fi

# 3) last resort: base16-eighties background
[ -z "$bg" ] && bg="2d2d2d"

r=$(printf '%d' "0x$(printf %s "$bg" | cut -c1-2)")
g=$(printf '%d' "0x$(printf %s "$bg" | cut -c3-4)")
b=$(printf '%d' "0x$(printf %s "$bg" | cut -c5-6)")

awk -v r="$r" -v g="$g" -v b="$b" -v f="$factor" \
  'BEGIN { printf "#%02x%02x%02x\n", int(r*f), int(g*f), int(b*f) }'
