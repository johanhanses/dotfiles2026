#!/usr/bin/env sh
# Tokyo Night palette — theme-aware, sourced by sketchybarrc and plugins.
# Detects macOS AppleInterfaceStyle: Dark ⇒ Tokyo Night Night, else Tokyo
# Night Day. Exports 0xAARRGGBB colors used throughout the bar.

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
  export BG="0xff1a1b26"
  export BG_DARK="0xff16161e"
  export FG="0xffc0caf5"
  export FG_DIM="0xff737aa2"
  export BLUE="0xff7aa2f7"
  export CYAN="0xff7dcfff"
  export MAGENTA="0xffbb9af7"
  export ORANGE="0xffff9e64"
  export YELLOW="0xffe0af68"
  export GREEN="0xff9ece6a"
  export RED="0xfff7768e"
else
  export BG="0xffe1e2e7"
  export BG_DARK="0xffd0d5e3"
  export FG="0xff3760bf"
  export FG_DIM="0xff68709a"
  export BLUE="0xff2e7de9"
  export CYAN="0xff007197"
  export MAGENTA="0xff9854f1"
  export ORANGE="0xffb15c00"
  export YELLOW="0xff8c6c3e"
  export GREEN="0xff587539"
  export RED="0xfff52a65"
fi
