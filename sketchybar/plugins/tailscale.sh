#!/usr/bin/env sh

GREEN="0xff9ece6a"
RED="0xfff7768e"
DIM="0xff737aa2"

TS_BIN=$(command -v tailscale 2>/dev/null)
if [ -z "$TS_BIN" ] && [ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]; then
  TS_BIN="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

if [ -z "$TS_BIN" ]; then
  sketchybar --set "$NAME" icon="󰖂" icon.color="$DIM" label=""
  exit 0
fi

STATE=$("$TS_BIN" status --json 2>/dev/null | grep -o '"BackendState":"[^"]*"' | head -1 | cut -d'"' -f4)

case "$STATE" in
  Running)
    sketchybar --set "$NAME" icon="󰒘" icon.color="$GREEN" label=""
    ;;
  *)
    sketchybar --set "$NAME" icon="󰒙" icon.color="$RED" label=""
    ;;
esac
