#!/bin/zsh
# Launch wrapper for the ttyd LaunchDaemon.
# Font client-options mirror ~/.config/ghostty/config as closely as xterm.js allows;
# the color theme is read from theme.json (managed by tinty via tinty-ttyd-theme.sh).
set -eu

TTYD="/opt/homebrew/bin/ttyd"
THEME_FILE="$HOME/.config/ttyd/theme.json"

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

exec "$TTYD" "${args[@]}" /bin/zsh -l
