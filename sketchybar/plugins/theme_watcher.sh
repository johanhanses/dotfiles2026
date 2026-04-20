#!/usr/bin/env sh
# Poll macOS appearance every tick; reload SketchyBar if it changed since
# last tick so the Tokyo Night palette swaps between Night and Day.

STATE_FILE="/tmp/sketchybar-theme-state"
CURRENT=$(defaults read -g AppleInterfaceStyle 2>/dev/null | head -1)
CURRENT=${CURRENT:-Light}

LAST=""
[ -f "$STATE_FILE" ] && LAST=$(cat "$STATE_FILE")

if [ "$CURRENT" != "$LAST" ]; then
  printf '%s' "$CURRENT" > "$STATE_FILE"
  # Skip the first-run reload (LAST empty) so we don't needlessly
  # rebuild the bar right after startup.
  if [ -n "$LAST" ]; then
    sketchybar --reload
  fi
fi
