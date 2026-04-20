#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

if ! command -v icalBuddy >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon="" icon.color="$FG_DIM" label="install icalBuddy"
  exit 0
fi

# icalBuddy prints events across two lines by default:
#   Event Title
#       <datetime line>
# We pin time format to 24h HH:MM so parsing out the start time is trivial.
OUTPUT=$(icalBuddy -nc -npn -eep "notes,url,location" -ea -n -li 1 -b "" -tf '%H:%M' -df '%Y-%m-%d' eventsToday 2>/dev/null)

if [ -z "$OUTPUT" ]; then
  sketchybar --set "$NAME" icon="" icon.color="$FG_DIM" label="no events"
  exit 0
fi

TITLE=$(printf '%s\n' "$OUTPUT" | sed -n '1p' | sed 's/^[[:space:]]*//')
# First HH:MM in the output is the start time (all-day events are excluded
# via `-ea`, so there's always a real start time to extract).
TIME=$(printf '%s\n' "$OUTPUT" | grep -oE '[0-9]{1,2}:[0-9]{2}' | head -1)

if [ -n "$TIME" ]; then
  LABEL="$TIME  $TITLE"
else
  LABEL="$TITLE"
fi

sketchybar --set "$NAME" icon="" icon.color="$FG" label="${LABEL:0:35}"
