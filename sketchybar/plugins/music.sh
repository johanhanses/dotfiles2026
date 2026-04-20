#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

STATE=$(osascript -e 'tell application "Music" to if it is running then get player state as string' 2>/dev/null)

if [ "$STATE" = "playing" ]; then
  TRACK=$(osascript -e 'tell application "Music" to get name of current track' 2>/dev/null)
  ARTIST=$(osascript -e 'tell application "Music" to get artist of current track' 2>/dev/null)
  LABEL="${ARTIST} — ${TRACK}"
  sketchybar --set "$NAME" drawing=on icon="󰎆" icon.color="$MAGENTA" label="${LABEL:0:40}"
else
  sketchybar --set "$NAME" drawing=off
fi
