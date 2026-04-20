#!/usr/bin/env sh

FG="0xffc0caf5"
DIM="0xff737aa2"

# Falun, Sweden (60.60,15.63) — hard-coded so the widget doesn't drift
# with IP geolocation (VPN, travel, Tailscale exit node, etc.).
WEATHER=$(curl -s --max-time 5 "wttr.in/60.60,15.63?format=%c+%t" 2>/dev/null | tr -d '\n' | head -c 30)

if [ -z "$WEATHER" ]; then
  sketchybar --set "$NAME" icon="" icon.color="$DIM" label="—"
else
  sketchybar --set "$NAME" icon.drawing=off label="$WEATHER" label.color="$FG"
fi
