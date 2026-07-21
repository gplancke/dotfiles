#!/bin/zsh
# Convert a tinty-generated Ghostty theme file into an xterm.js ITheme JSON
# consumed by ttyd (via ttyd-launch.sh). Called by the `tinted-ttyd` tinty hook
# with %f = path to the freshly generated Ghostty theme; falls back to the
# canonical location when run by hand.
set -eu

SRC="${1:-$HOME/.config/ghostty/themes/tinted-theming}"
OUT="$HOME/.config/ttyd/theme.json"

if [[ ! -r "$SRC" ]]; then
  echo "tinty-ttyd-theme: source theme not readable: $SRC" >&2
  exit 1
fi

tmp="$(mktemp "${OUT}.XXXXXX")"

awk -F' *= *' '
  $1 == "palette"              { pal[$2] = $3 }
  $1 == "background"           { bg   = $2 }
  $1 == "foreground"           { fg   = $2 }
  $1 == "cursor-color"         { cur  = $2 }
  $1 == "selection-background" { selbg = $2 }
  $1 == "selection-foreground" { selfg = $2 }
  END {
    printf "{"
    printf "\"foreground\":\"%s\",",          fg
    printf "\"background\":\"%s\",",          bg
    printf "\"cursor\":\"%s\",",              cur
    printf "\"cursorAccent\":\"%s\",",        bg
    printf "\"selectionBackground\":\"%s\",", selbg
    printf "\"selectionForeground\":\"%s\",", selfg
    printf "\"black\":\"%s\",",         pal[0]
    printf "\"red\":\"%s\",",           pal[1]
    printf "\"green\":\"%s\",",         pal[2]
    printf "\"yellow\":\"%s\",",        pal[3]
    printf "\"blue\":\"%s\",",          pal[4]
    printf "\"magenta\":\"%s\",",       pal[5]
    printf "\"cyan\":\"%s\",",          pal[6]
    printf "\"white\":\"%s\",",         pal[7]
    printf "\"brightBlack\":\"%s\",",   pal[8]
    printf "\"brightRed\":\"%s\",",     pal[9]
    printf "\"brightGreen\":\"%s\",",   pal[10]
    printf "\"brightYellow\":\"%s\",",  pal[11]
    printf "\"brightBlue\":\"%s\",",    pal[12]
    printf "\"brightMagenta\":\"%s\",", pal[13]
    printf "\"brightCyan\":\"%s\",",    pal[14]
    printf "\"brightWhite\":\"%s\"",    pal[15]
    printf "}\n"
  }
' "$SRC" > "$tmp"

mv -f "$tmp" "$OUT"    # atomic; triggers the daemon's WatchPaths -> restart
echo "tinty-ttyd-theme: wrote $OUT"
