#!/usr/bin/env sh

FG="0xffc0caf5"
DIM="0xff737aa2"

WEATHER=$(curl -s --max-time 5 "wttr.in/?format=%c+%t" 2>/dev/null | tr -d '\n' | head -c 30)

if [ -z "$WEATHER" ]; then
  sketchybar --set "$NAME" icon="" icon.color="$DIM" label="—"
else
  sketchybar --set "$NAME" icon.drawing=off label="$WEATHER" label.color="$FG"
fi
