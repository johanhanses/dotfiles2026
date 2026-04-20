#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

# Only inspect the app when it's running — lsappinfo would otherwise
# launch it.
if ! pgrep -x "Mattermost" >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

LINE=$(lsappinfo info -app "Mattermost" 2>/dev/null | grep StatusLabel)
if [ -z "$LINE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COUNT=$(echo "$LINE" | awk -F'"' '{print $2}')
if [ -z "$COUNT" ] || [ "$COUNT" = "0" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on icon="" icon.color="$BLUE" label="$COUNT"
fi
