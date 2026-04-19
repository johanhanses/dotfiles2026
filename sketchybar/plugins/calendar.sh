#!/usr/bin/env sh

FG="0xffc0caf5"
DIM="0xff737aa2"

if ! command -v icalBuddy >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon="" icon.color="$DIM" label="install icalBuddy"
  exit 0
fi

NEXT=$(icalBuddy -nc -npn -eep "notes,url,location" -ea -n -li 1 -b "" eventsToday 2>/dev/null | head -1 | sed 's/^[[:space:]]*//')

if [ -z "$NEXT" ]; then
  sketchybar --set "$NAME" icon="" icon.color="$DIM" label="no events"
else
  sketchybar --set "$NAME" icon="" icon.color="$FG" label="${NEXT:0:30}"
fi
