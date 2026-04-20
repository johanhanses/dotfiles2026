# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a cross-platform dotfiles repository supporting macOS (primary). The repository uses a symlink-based installation system backed by a `Brewfile` for package provisioning.

## Key Components

- **Platform-specific install scripts**: `mac-install.sh` — creates symlinks to configuration files in user's home directory and runs `brew bundle`
- **Brewfile**: declares all formulae, casks, and fonts for the macOS setup
- **macOS defaults**: `scripts/macos-defaults.sh` applies system preferences (Dock, Finder, keyboard, screenshots, menu bar hidden)
- **ZSH configurations**: Platform-specific zsh configs in `zshrc/mac/`
- **Neovim configuration**: LazyVim-based setup in `nvim/` directory with Tokyo Night Night (dark) / Day (light) auto-switch
- **Terminal configurations**:
  - Tmux config with Tokyo Night status bar
  - Ghostty terminal configuration with Tokyo Night theme, Geist Mono Nerd Font, hidden title bar, split keybinds
- **Window manager**: `aerospace/` — tiling WM config (Aerospace) with hjkl focus/move/resize, 9 workspaces, per-monitor outer.top (4 built-in, 34 external)
- **Status bar**: `sketchybar/` — SketchyBar with workspace indicators, front-app, music, mail, calendar, weather, tailscale, wifi (icon-only), cpu, memory, volume, battery, clock. CPU/Memory/Volume auto-hide on the built-in display
- **Launcher**: Raycast replaces Spotlight (see `RAYCAST-SETUP.md`)
- **File manager**: `yazi/` — Yazi with custom keymap (gh/gc/gd/gr jumps) and iterm2 image preview
- **System monitoring**: btop configuration
- **RSS reader**: newsboat configuration
- **Keybindings reference**: `KEYBINDINGS.md` — full shortcut reference across all apps

## Common Commands

**Installation (run from repository root):**
```bash
./mac-install.sh              # symlinks + brew bundle
./scripts/macos-defaults.sh   # macOS system tweaks
```

**Development IDE layout (tmux):**
```bash
./scripts/ide
```

**Tmux configuration reload:**
```bash
# Inside tmux session
<prefix> + r
```

## File Structure Notes

- Configuration files are organized by application in their own directories
- Neovim uses LazyVim as the base configuration with custom plugins in `lua/plugins/`
- Tokyo Night theme (Night dark / Day light) is used across Neovim, tmux, Ghostty, btop, SketchyBar, yazi, delta, bat, newsboat
- Private configurations (like .kube) are expected in a separate `dotfiles-private` repository

## Theme

Two theme families are supported: **Tokyo Night** (default) and **Everforest**. Toggle with `Ctrl+Cmd+Alt+T` via Aerospace, or run `scripts/theme-switch [tokyonight|everforest]`. The active family is stored in `~/.config/theme-family`. macOS Dark/Light still drives the Night/Day or Dark/Light variant **within** whichever family is active — four visible combinations, one toggle.

**Everforest contrast**: Hard for dark, Medium for light (matches what Ghostty + btop ship).

Dark mode uses Tokyo Night Night, light mode uses Tokyo Night Day (auto-switches based on OS):
- Neovim: `tokyonight-night` / `tokyonight-day` — custom colorschemes in `nvim/colors/`, auto-switches on focus
- Ghostty: built-in `tokyonight` theme
- tmux: Tokyo Night palette (`#1a1b26` bg, `#7aa2f7` accent)
- SketchyBar: Tokyo Night palette in `sketchybar/plugins/colors.sh`, auto-switches via `plugins/theme_watcher.sh`
- Yazi: Tokyo Night `yazi/theme.toml`
- delta (git): `syntax-theme = tokyonight_night`
- bat: `BAT_THEME="tokyonight_night"`
- btop: `tokyo-night`
- starship: Tokyo Night preset (`starship.toml`)
- newsboat: Tokyo Night colors
