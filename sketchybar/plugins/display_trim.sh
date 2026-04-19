#!/usr/bin/env sh

# Hide wide/low-priority items when the focused monitor is the built-in
# MacBook display. External monitors get the full bar.

FOCUSED=$(aerospace list-monitors --focused 2>/dev/null)

if echo "$FOCUSED" | grep -qi "built-in"; then
  sketchybar --set weather drawing=off
  sketchybar --set calendar drawing=off
else
  sketchybar --set weather drawing=on
  sketchybar --set calendar drawing=on
fi
