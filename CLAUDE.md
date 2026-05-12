# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

A minimal macOS dotfiles repository. Symlink-based installation backed by a `Brewfile`. The setup deliberately leans on native macOS — Spotlight as the launcher, no tiling WM, no custom status bar — and keeps the configured surface area small.

## Configured Apps

Only these directories ship configs:

- `nvim/` — Neovim, custom `lazy.nvim` setup (not LazyVim), plugins in `lua/plugins/`, colorscheme `wildcharm`
- `tmux/` — tmux with `C-a` prefix, vi-mode, vim-aware pane navigation, macOS clipboard integration
- `ghostty/` — Ghostty terminal, GeistMono Nerd Font, Builtin Light/Dark theme that auto-switches with macOS
- `zshrc/mac/` — zsh config: history, completions, autosuggestions + syntax-highlighting, custom `vcs_info` prompt, mise, fzf+fd, aliases
- `btop/` — btop with `tokyo-night` theme
- `newsboat/` — RSS reader
- `matterhorn/` — Mattermost TUI client

## Install & Setup

```bash
./mac-install.sh              # symlinks + optional brew bundle
./scripts/macos-defaults.sh   # macOS system tweaks (Dock, Finder, keyboard, screenshots)
```

`mac-install.sh` also actively **removes** previous-setup leftovers: Aerospace, SketchyBar, Raycast, Yazi, Starship, zoxide, ical-buddy, ffmpegthumbnailer, poppler — plus `~/.config/{aerospace,sketchybar,yazi}`, `~/.config/starship.toml`, `~/.config/theme-family`, and apps Moom/Cyberduck/Chromium. After install, rebind `Cmd+Space` to Spotlight in System Settings.

## Scripts

- `scripts/ide` — tmux IDE layout
- `scripts/macos-defaults.sh` — apply macOS preferences
- `scripts/lastshot` — screenshot helper
- `scripts/bk`, `scripts/pomo` — misc helpers

## Themes

- **Ghostty**: macOS-native `Builtin Light` / `Builtin Dark`, auto-switches with OS
- **btop**: `tokyo-night`
- **Neovim**: `wildcharm` colorscheme
- **bat**: `ansi`
- **tmux**: no theme directives — uses defaults

There is no theme-switch script and no window-manager keybinding for theme toggling. Light/Dark switching is handled by a native macOS Spotlight workflow shortcut (outside this repo).

## Notes

- `nvim/init.lua` bootstraps `lazy.nvim` directly; LazyVim is not used.
- `nvim.lazyvim/` is a leftover/reference directory and is not symlinked by `mac-install.sh`.
- `OMARCHY-COMPARISON.md` documents how this setup compares to an Omarchy-inspired plan.
- `KEYBINDINGS.md` is the keybindings reference.
- Private configs (e.g. `.kube`) live in a separate `dotfiles-private` repo and are symlinked in if present.
- Launcher: native Spotlight (Cmd+Space). No Raycast.
