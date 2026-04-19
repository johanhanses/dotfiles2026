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

SSID=$(networksetup -getairportnetwork "$IFACE" 2>/dev/null | awk -F': ' '{print $2}')
if [ -z "$SSID" ] || [ "$SSID" = "You are not associated with an AirPort network." ]; then
  sketchybar --set "$NAME" icon="󰖩" icon.color="$BLUE" label=""
else
  sketchybar --set "$NAME" icon="󰖩" icon.color="$BLUE" label="${SSID:0:18}"
fi
