#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

# SketchyBar runs under launchd with a limited PATH (/usr/bin:/bin:...),
# so even if `tailscale` is on the user's shell PATH, `command -v` may
# miss it. Explicitly search common install locations.
TS_BIN=""
for candidate in \
  "/usr/local/bin/tailscale" \
  "/opt/homebrew/bin/tailscale" \
  "/Applications/Tailscale.app/Contents/MacOS/Tailscale" \
  "$(command -v tailscale 2>/dev/null)"
do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then
    TS_BIN="$candidate"
    break
  fi
done

if [ -n "$TS_BIN" ]; then
  STATE=$("$TS_BIN" status --json 2>/dev/null | grep -o '"BackendState":"[^"]*"' | head -1 | cut -d'"' -f4)
  case "$STATE" in
    Running)
      sketchybar --set "$NAME" icon="󰒘" icon.color="$GREEN" label=""
      exit 0
      ;;
    NoState|NeedsLogin|Stopped)
      sketchybar --set "$NAME" icon="󰒙" icon.color="$RED" label=""
      exit 0
      ;;
  esac
fi

# Fallback: Tailscale assigns a 100.x CGNAT address to its utun interface
# when connected. Reliable signal even without the CLI.
if ifconfig 2>/dev/null | grep -q "inet 100\."; then
  sketchybar --set "$NAME" icon="󰒘" icon.color="$GREEN" label=""
else
  sketchybar --set "$NAME" icon="󰒙" icon.color="$RED" label=""
fi
