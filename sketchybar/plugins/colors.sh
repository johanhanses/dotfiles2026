#!/usr/bin/env sh
# Theme-aware palette — sourced by sketchybarrc and plugins. Branches on
# two dimensions:
#   1. THEME family from ~/.config/theme-family (tokyonight | everforest)
#   2. macOS AppleInterfaceStyle (Dark or not-set ⇒ Light)
# Exports 0xAARRGGBB colors used throughout the bar.

FAMILY=$(cat "$HOME/.config/theme-family" 2>/dev/null || echo tokyonight)
if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
  MODE=dark
else
  MODE=light
fi

case "$FAMILY-$MODE" in
  tokyonight-dark)
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
    ;;
  tokyonight-light)
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
    ;;
  everforest-dark)
    export BG="0xff1E2326"
    export BG_DARK="0xff272E33"
    export FG="0xffD3C6AA"
    export FG_DIM="0xff859289"
    export BLUE="0xff7FBBB3"
    export CYAN="0xff83C092"
    export MAGENTA="0xffD699B6"
    export ORANGE="0xffE69875"
    export YELLOW="0xffDBBC7F"
    export GREEN="0xffA7C080"
    export RED="0xffE67E80"
    ;;
  everforest-light)
    export BG="0xffFDF6E3"
    export BG_DARK="0xffF4F0D9"
    export FG="0xff5C6A72"
    export FG_DIM="0xff829181"
    export BLUE="0xff3A94C5"
    export CYAN="0xff35A77C"
    export MAGENTA="0xffDF69BA"
    export ORANGE="0xffF57D26"
    export YELLOW="0xffDFA000"
    export GREEN="0xff8DA101"
    export RED="0xffF85552"
    ;;
esac
