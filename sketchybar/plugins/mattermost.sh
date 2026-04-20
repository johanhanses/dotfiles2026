#!/usr/bin/env sh

. "$CONFIG_DIR/plugins/colors.sh"

# Mattermost Desktop's dock badge (lsappinfo StatusLabel) isn't always
# populated — the app doesn't surface mentions that way reliably. Query
# the REST API directly instead, using the same credentials file that
# drives scripts/mattermost-theme-sync.

CONFIG_FILE="$HOME/Repos/github.com/johanhanses/dotfiles-private/mattermost/config"

if [ ! -f "$CONFIG_FILE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# shellcheck disable=SC1090
. "$CONFIG_FILE"

if [ -z "$MATTERMOST_URL" ] || [ -z "$MATTERMOST_TOKEN" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Sum mention_count across all teams. mention_count is "you were @'d or
# replied to" — that's the notification-worthy signal. msg_count would
# include every unread message (too noisy for the bar).
MENTIONS=$(curl -sf --max-time 3 \
  -H "Authorization: Bearer $MATTERMOST_TOKEN" \
  "$MATTERMOST_URL/api/v4/users/me/teams/unread" 2>/dev/null \
  | jq '[.[].mention_count] | add // 0' 2>/dev/null)

if [ -z "$MENTIONS" ] || [ "$MENTIONS" = "0" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" \
    drawing=on \
    icon="" \
    icon.color="$BG" \
    label="$MENTIONS" \
    label.color="$BG" \
    background.drawing=on \
    background.color="$BLUE"
fi
