#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

# Only read from Mail.app when it's actually running — asking AppleScript
# otherwise would launch it.
if ! pgrep -x Mail >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COUNT=$(osascript -e 'tell application "Mail" to get unread count of inbox' 2>/dev/null)

case "$COUNT" in
  ""|"0")
    sketchybar --set "$NAME" drawing=off
    ;;
  *)
    sketchybar --set "$NAME" drawing=on icon="" icon.color="$RED" label="$COUNT"
    ;;
esac
