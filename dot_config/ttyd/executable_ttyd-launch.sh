#!/usr/bin/env bash
# Launch wrapper for the ttyd service (macOS LaunchAgent / Linux systemd user).
# Font client-options mirror ~/.config/ghostty/config as closely as xterm.js allows;
# the color theme is read from theme.json (managed by tinty via tinty-ttyd-theme.sh).
set -euo pipefail

THEME_FILE="$HOME/.config/ttyd/theme.json"

# Resolve the ttyd binary: honour $TTYD, then PATH, then common install dirs.
TTYD="${TTYD:-$(command -v ttyd 2>/dev/null || true)}"
if [[ -z "$TTYD" ]]; then
  for c in /opt/homebrew/bin/ttyd /usr/local/bin/ttyd /usr/bin/ttyd; do
    [[ -x "$c" ]] && { TTYD="$c"; break; }
  done
fi
[[ -n "$TTYD" ]] || { echo "ttyd-launch: ttyd binary not found on PATH" >&2; exit 127; }

# Shell ttyd opens in the browser: $SHELL, else zsh, else bash, else sh.
LOGIN_SHELL="${TTYD_SHELL:-${SHELL:-}}"
if [[ -z "$LOGIN_SHELL" || ! -x "$LOGIN_SHELL" ]]; then
  LOGIN_SHELL="$(command -v zsh || command -v bash || echo /bin/sh)"
fi

# --- ghostty font settings, mapped onto xterm.js client options ---
#   ghostty: font-family = JetBrainsMono Nerd Font Mono
#            font-size   = 10
#            font-style  = Bold Italic + font-thicken -> bold weights (xterm.js has
#                          no global-italic option, so italic is not reproduced)
#            adjust-cell-width  = -8%  -> letterSpacing (px, approximate)
#            adjust-cell-height = 11%  -> lineHeight (multiplier, approximate)
args=(
  -i 127.0.0.1          # localhost only
  -p 7681               # default ttyd port
  -W                    # writable / interactive
  -w "$HOME"            # start in the home directory
  -T xterm-256color
  -t 'fontFamily=JetBrainsMono Nerd Font Mono'
  -t 'fontSize=10'
  -t 'fontWeight=bold'
  -t 'fontWeightBold=bold'
  -t 'letterSpacing=-0.5'
  -t 'lineHeight=1.11'
)

# Color theme (from tinty). Passed as a single JSON client-option if present.
if [[ -r "$THEME_FILE" ]]; then
  args+=(-t "theme=$(cat "$THEME_FILE")")
fi

exec "$TTYD" "${args[@]}" "$LOGIN_SHELL" -l
