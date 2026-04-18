#!/usr/bin/env sh

GREEN="0xff9ece6a"
YELLOW="0xffe0af68"
ORANGE="0xffff9e64"
RED="0xfff7768e"

PERCENTAGE="$(pmset -g batt | grep -Eo '\d+%' | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""; COLOR="$GREEN" ;;
  [6-8][0-9]) ICON=""; COLOR="$GREEN" ;;
  [3-5][0-9]) ICON=""; COLOR="$YELLOW" ;;
  [1-2][0-9]) ICON=""; COLOR="$ORANGE" ;;
  *)          ICON=""; COLOR="$RED" ;;
esac

if [ -n "$CHARGING" ]; then
  ICON=""
  COLOR="$GREEN"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
