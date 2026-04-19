#!/usr/bin/env sh

RED="0xfff7768e"

LINE=$(lsappinfo info -app "Mail" 2>/dev/null | grep StatusLabel)

if [ -z "$LINE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COUNT=$(echo "$LINE" | awk -F'"' '{print $2}')

if [ -z "$COUNT" ] || [ "$COUNT" = "0" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on icon="" icon.color="$RED" label="$COUNT"
fi
