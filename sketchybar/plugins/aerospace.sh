#!/usr/bin/env sh

BLUE="0xff7aa2f7"
BG_DARK="0xff16161e"
FG="0xffc0caf5"

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
