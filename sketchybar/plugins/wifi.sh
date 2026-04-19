#!/usr/bin/env sh

BLUE="0xff7aa2f7"
DIM="0xff737aa2"

IFACE=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')
[ -z "$IFACE" ] && IFACE="en0"

STATUS=$(ifconfig "$IFACE" 2>/dev/null | awk '/status:/ {print $2}')

if [ "$STATUS" != "active" ]; then
  sketchybar --set "$NAME" icon="󰖪" icon.color="$DIM" label="offline"
  exit 0
fi

# Try ipconfig first — works on Sonoma+ without Location Services permission
SSID=$(ipconfig getsummary "$IFACE" 2>/dev/null | awk -F'SSID : ' '/  SSID : / {print $2; exit}')

# Fallback to networksetup (needs Location permission on recent macOS)
if [ -z "$SSID" ]; then
  SSID=$(networksetup -getairportnetwork "$IFACE" 2>/dev/null | awk -F': ' '{print $2}')
fi

case "$SSID" in
  ""|"You are not associated"*|"Error"*|*"not available"*)
    sketchybar --set "$NAME" icon="󰖩" icon.color="$BLUE" label=""
    ;;
  *)
    sketchybar --set "$NAME" icon="󰖩" icon.color="$BLUE" label="${SSID:0:18}"
    ;;
esac
