#!/usr/bin/env sh

FG="0xffc0caf5"
YELLOW="0xffe0af68"
RED="0xfff7768e"

PAGE_SIZE=$(vm_stat | awk '/page size/ {print $8}')
[ -z "$PAGE_SIZE" ] && PAGE_SIZE=16384

PAGES_ACTIVE=$(vm_stat | awk '/Pages active/ {gsub(/\./, "", $3); print $3}')
PAGES_WIRED=$(vm_stat | awk '/Pages wired down/ {gsub(/\./, "", $4); print $4}')
PAGES_COMPRESSED=$(vm_stat | awk '/Pages occupied by compressor/ {gsub(/\./, "", $5); print $5}')
TOTAL_BYTES=$(sysctl -n hw.memsize)

USED_BYTES=$(( (PAGES_ACTIVE + PAGES_WIRED + PAGES_COMPRESSED) * PAGE_SIZE ))
USED_GB=$(awk -v b="$USED_BYTES" 'BEGIN {printf "%.1f", b / 1073741824}')
TOTAL_GB=$(awk -v b="$TOTAL_BYTES" 'BEGIN {printf "%.0f", b / 1073741824}')
PCT=$(awk -v u="$USED_BYTES" -v t="$TOTAL_BYTES" 'BEGIN {printf "%.0f", (u / t) * 100}')

COLOR="$FG"
if [ "$PCT" -ge 85 ]; then
  COLOR="$RED"
elif [ "$PCT" -ge 65 ]; then
  COLOR="$YELLOW"
fi

sketchybar --set "$NAME" icon.color="$COLOR" label="${USED_GB}/${TOTAL_GB}G"
