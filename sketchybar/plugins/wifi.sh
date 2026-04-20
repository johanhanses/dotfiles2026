#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

IFACE=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')
[ -z "$IFACE" ] && IFACE="en0"

STATUS=$(ifconfig "$IFACE" 2>/dev/null | awk '/status:/ {print $2}')

if [ "$STATUS" = "active" ]; then
  sketchybar --set "$NAME" icon="󰖩" icon.color="$BLUE"
else
  sketchybar --set "$NAME" icon="󰖪" icon.color="$FG_DIM"
fi
