#!/usr/bin/env sh

FG="0xffc0caf5"
YELLOW="0xffe0af68"
RED="0xfff7768e"

CPU=$(top -l 1 -s 0 | awk '/CPU usage/ {print $3}' | tr -d '%')
CPU_INT=${CPU%.*}
[ -z "$CPU_INT" ] && CPU_INT=0

COLOR="$FG"
if [ "$CPU_INT" -ge 80 ]; then
  COLOR="$RED"
elif [ "$CPU_INT" -ge 50 ]; then
  COLOR="$YELLOW"
fi

sketchybar --set "$NAME" icon.color="$COLOR" label="${CPU_INT}%"
