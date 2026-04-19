#!/usr/bin/env sh

# On the built-in MacBook display hide system stats (cpu/memory/volume)
# to keep the bar readable. External monitors show the full set.

FOCUSED=$(aerospace list-monitors --focused 2>/dev/null)

if echo "$FOCUSED" | grep -qi "built-in"; then
  sketchybar --set cpu drawing=off
  sketchybar --set memory drawing=off
  sketchybar --set volume drawing=off
else
  sketchybar --set cpu drawing=on
  sketchybar --set memory drawing=on
  sketchybar --set volume drawing=on
fi
