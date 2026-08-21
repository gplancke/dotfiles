#!/usr/bin/env bash
# Install (or uninstall) the ttyd web terminal as a background service that
# starts automatically and restarts when tinty rewrites theme.json.
#
#   macOS : per-user LaunchAgent   ~/Library/LaunchAgents/com.ttyd.plist
#           (starts at GUI login, no sudo; WatchPaths restarts on theme change)
#   Linux : systemd --user units   ~/.config/systemd/user/ttyd.{service,path}
#           (a .path unit restarts ttyd when theme.json changes)
#
# Usage:  ./install-service.sh            # install + start
#         ./install-service.sh uninstall  # stop + remove
set -euo pipefail

DIR="$HOME/.config/ttyd"
LAUNCH="$DIR/ttyd-launch.sh"
THEME="$DIR/theme.json"
LOG="$DIR/ttyd.log"
LABEL="com.ttyd"
PORT=7681

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n'   "$*" >&2; exit 1; }

ACTION="${1:-install}"
OS="$(uname -s)"

[[ -f "$LAUNCH" ]] || die "launch script missing: $LAUNCH"
chmod +x "$LAUNCH" 2>/dev/null || true
[[ -f "$DIR/tinty-ttyd-theme.sh" ]] && chmod +x "$DIR/tinty-ttyd-theme.sh" 2>/dev/null || true
command -v ttyd >/dev/null 2>&1 || warn "ttyd not found on PATH now — the service will fail until it is installed"

# ---- macOS (LaunchAgent) ----------------------------------------------------
mac_plist="$HOME/Library/LaunchAgents/$LABEL.plist"
mac_domain="gui/$(id -u)"

mac_uninstall() {
  if launchctl print "$mac_domain/$LABEL" >/dev/null 2>&1; then
    log "unloading LaunchAgent"
    launchctl bootout "$mac_domain/$LABEL" 2>/dev/null || true
  fi
  rm -f "$mac_plist" && log "removed $mac_plist"
}

mac_install() {
  # Retire the old hand-installed root LaunchDaemon if present — it would fight
  # the LaunchAgent for port $PORT.
  if [[ -f "/Library/LaunchDaemons/$LABEL.plist" ]]; then
    warn "old root LaunchDaemon found at /Library/LaunchDaemons/$LABEL.plist (needs sudo to remove; clashes on port $PORT)"
    if [[ -t 0 ]]; then
      read -r -p "Remove it now with sudo? [y/N] " ans || ans=""
      if [[ "$ans" == [yY]* ]]; then
        sudo launchctl bootout "system/$LABEL" 2>/dev/null || true
        sudo rm -f "/Library/LaunchDaemons/$LABEL.plist" && log "old LaunchDaemon removed"
      else
        warn "left in place — remove later: sudo launchctl bootout system/$LABEL && sudo rm /Library/LaunchDaemons/$LABEL.plist"
      fi
    else
      warn "non-interactive shell — remove it manually: sudo launchctl bootout system/$LABEL && sudo rm /Library/LaunchDaemons/$LABEL.plist"
    fi
  fi

  local ttyd_dir
  ttyd_dir="$(dirname "$(command -v ttyd 2>/dev/null || echo /opt/homebrew/bin/ttyd)")"

  mkdir -p "$HOME/Library/LaunchAgents"
  log "writing $mac_plist"
  cat > "$mac_plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>

    <key>ProgramArguments</key>
    <array>
        <string>$LAUNCH</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>

    <!-- tinty rewrites theme.json on apply; launchd restarts ttyd to pick it up -->
    <key>WatchPaths</key>
    <array>
        <string>$THEME</string>
    </array>

    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>$HOME</string>
        <key>PATH</key>
        <string>$ttyd_dir:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>

    <key>StandardOutPath</key>
    <string>$LOG</string>
    <key>StandardErrorPath</key>
    <string>$LOG</string>
</dict>
</plist>
PLIST

  plutil -lint "$mac_plist" >/dev/null || die "generated plist failed validation"

  log "loading LaunchAgent into $mac_domain"
  launchctl bootout "$mac_domain/$LABEL" 2>/dev/null || true
  launchctl bootstrap "$mac_domain" "$mac_plist"
  launchctl enable "$mac_domain/$LABEL" 2>/dev/null || true
  launchctl kickstart -k "$mac_domain/$LABEL" 2>/dev/null || true

  sleep 1
  if launchctl print "$mac_domain/$LABEL" 2>/dev/null | grep -q 'state = running'; then
    log "ttyd is running at http://127.0.0.1:$PORT"
  else
    warn "loaded but not confirmed running — check: tail -f $LOG"
  fi
  log "logs:      tail -f $LOG"
  log "uninstall: $0 uninstall"
}

# ---- Linux (systemd --user) -------------------------------------------------
units="$HOME/.config/systemd/user"

linux_uninstall() {
  systemctl --user disable --now ttyd.service ttyd-theme.path 2>/dev/null || true
  rm -f "$units/ttyd.service" "$units/ttyd-theme.path" "$units/ttyd-theme.service"
  systemctl --user daemon-reload 2>/dev/null || true
  log "removed systemd user units"
}

linux_install() {
  command -v systemctl >/dev/null 2>&1 || die "systemctl not found (is this a systemd system?)"
  mkdir -p "$units"

  log "writing $units/ttyd.service"
  cat > "$units/ttyd.service" <<UNIT
[Unit]
Description=ttyd web terminal
After=default.target

[Service]
ExecStart=$LAUNCH
Restart=always
RestartSec=1

[Install]
WantedBy=default.target
UNIT

  # A .path unit is the systemd equivalent of launchd WatchPaths: on theme.json
  # change it triggers a oneshot that restarts ttyd (a .path can only *start* its
  # Unit=, so the oneshot does the restart).
  log "writing $units/ttyd-theme.path"
  cat > "$units/ttyd-theme.path" <<UNIT
[Unit]
Description=Watch ttyd theme.json (tinty) and restart ttyd on change

[Path]
PathModified=$THEME
Unit=ttyd-theme.service

[Install]
WantedBy=default.target
UNIT

  log "writing $units/ttyd-theme.service"
  cat > "$units/ttyd-theme.service" <<UNIT
[Unit]
Description=Restart ttyd to pick up the new tinty theme

[Service]
Type=oneshot
ExecStart=systemctl --user try-restart ttyd.service
UNIT

  systemctl --user daemon-reload
  systemctl --user enable --now ttyd.service ttyd-theme.path
  loginctl enable-linger "$USER" 2>/dev/null \
    || warn "could not enable linger — service won't run without an active session; run: sudo loginctl enable-linger $USER"

  systemctl --user --no-pager --lines=0 status ttyd.service || true
  log "ttyd should be at http://127.0.0.1:$PORT"
  log "logs:      journalctl --user -u ttyd.service -f"
  log "uninstall: $0 uninstall"
}

# ---- dispatch ---------------------------------------------------------------
case "$OS" in
  Darwin) if [[ "$ACTION" == "uninstall" ]]; then mac_uninstall;   else mac_install;   fi ;;
  Linux)  if [[ "$ACTION" == "uninstall" ]]; then linux_uninstall; else linux_install; fi ;;
  *)      die "unsupported OS: $OS (this installer handles macOS and Linux/systemd)" ;;
esac
