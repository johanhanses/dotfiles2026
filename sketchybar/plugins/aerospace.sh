#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

sid="$1"
focused="$(aerospace list-workspaces --focused 2>/dev/null)"

if [ "$sid" = "$focused" ]; then
  sketchybar --set "space.$sid" \
    background.drawing=on \
    background.color="$BLUE" \
    icon.color="$BG_DARK"
else
  sketchybar --set "space.$sid" \
    background.drawing=off \
    icon.color="$FG"
fi
