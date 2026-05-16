# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

A minimal macOS dotfiles repository. Symlink-based installation backed by a `Brewfile`. The setup deliberately leans on native macOS — Spotlight as the launcher, Moom for window management (lightweight, GUI-configured, no tiling WM), no custom status bar — and keeps the configured surface area small.

## Configured Apps

Only these directories ship configs:

- `nvim/` — Neovim, custom `lazy.nvim` setup (not LazyVim), plugins in `lua/plugins/`, Atom One Dark/Light via `onedarkpro.nvim` (auto-switches with macOS via `auto-dark-mode.nvim`)
- `tmux/` — tmux with `C-a` prefix, vi-mode, vim-aware pane navigation, macOS clipboard integration; tpm with `tmux-sensible` + `tmux-yank`; Atom One Dark/Light themes in `tmux/themes/`
- `ghostty/` — Ghostty terminal, GeistMono Nerd Font, Atom One Light/Dark that auto-switches with macOS
- `zshrc/mac/` — zsh config: history, completions, autosuggestions + syntax-highlighting, custom `vcs_info` prompt, mise, fzf+fd, aliases
- `btop/` — btop with `tokyo-night` theme
- `newsboat/` — RSS reader
- `matterhorn/` — Mattermost TUI client

## Install & Setup

```bash
./mac-install.sh              # symlinks + optional brew bundle
./scripts/macos-defaults.sh   # macOS system tweaks (Dock, Finder, keyboard, screenshots)
```

`mac-install.sh` also actively **removes** previous-setup leftovers: Aerospace, SketchyBar, Raycast, Yazi, Starship, zoxide, ical-buddy, ffmpegthumbnailer, poppler — plus `~/.config/{aerospace,sketchybar,yazi}`, `~/.config/starship.toml`, `~/.config/theme-family`, and apps Cyberduck/Chromium. After install, rebind `Cmd+Space` to Spotlight in System Settings.

## Scripts

- `scripts/ide` — tmux IDE layout
- `scripts/macos-defaults.sh` — apply macOS preferences
- `scripts/lastshot` — screenshot helper
- `scripts/bk`, `scripts/pomo` — misc helpers
- `scripts/theme-sync` — re-source tmux Atom One theme + push Atom One palette to Mattermost Desktop via REST API; invoked by the macOS Spotlight workflow shortcut after toggling appearance

## Themes

- **Ghostty**: `Atom One Light` / `Atom One Dark`, auto-switches via `window-theme = auto`
- **Neovim**: Atom One via `olimorris/onedarkpro.nvim`; light/dark follows macOS via `f-person/auto-dark-mode.nvim` (~3s polling)
- **tmux**: Atom One Dark/Light theme files in `tmux/themes/`, sourced at startup by `if-shell` on `AppleInterfaceStyle`; re-sourced on toggle by `scripts/theme-sync`
- **btop**: Atom One Dark/Light theme files in `btop/themes/`; `color_theme` line in `btop.conf` rewritten by `scripts/theme-sync`
- **bat**: `OneHalfDark` / `OneHalfLight` (closest built-in to Atom One); `BAT_THEME` exported per-shell in `.zshrc` based on `AppleInterfaceStyle` at shell init
- **git-delta**: `OneHalfDark` / `OneHalfLight`; settings come from `~/themes.gitconfig` (included by `.gitconfig`) which `scripts/theme-sync` rewrites
- **newsboat**: 16-color ANSI, follows the terminal palette with no extra wiring
- **Mattermost Desktop**: palette set by `scripts/theme-sync` via the prefs REST API (reads `MATTERMOST_URL`/`MATTERMOST_TOKEN` from `dotfiles-private/mattermost/config`)
- **Matterhorn TUI**: unchanged — has its own theme overlays under `matterhorn/`, not auto-switched

Light/Dark switching is handled by a native macOS Spotlight workflow shortcut (outside this repo). The shortcut toggles `AppleInterfaceStyle` and then runs `scripts/theme-sync` so tmux + btop + git-delta + Mattermost catch up. Ghostty and Neovim handle themselves; bat picks up the new theme on next shell. `<prefix>+r` in tmux also runs `theme-sync` as a manual catch-up.

## Notes

- `nvim/init.lua` bootstraps `lazy.nvim` directly; LazyVim is not used.
- `nvim.lazyvim/` is a leftover/reference directory and is not symlinked by `mac-install.sh`.
- `OMARCHY-COMPARISON.md` documents how this setup compares to an Omarchy-inspired plan.
- `KEYBINDINGS.md` is the keybindings reference.
- Private configs (e.g. `.kube`) live in a separate `dotfiles-private` repo and are symlinked in if present.
- Launcher: native Spotlight (Cmd+Space). No Raycast.
- Window manager: **Moom 3 (classic)** — installed manually from manytricks.com, **not** via the `moom` Homebrew cask (which is Moom 4.x and intentionally avoided). Configured via the Moom GUI; preferences live in `~/Library/Preferences/com.manytricks.Moom.plist` and are not currently versioned in this repo. The `mac-install.sh` cleanup list deliberately excludes Moom.app.
- **Claude-native worktrees** — using `claude --worktree <name>` (built into Claude Code 2.x) for per-feature sessions. Worktrees land at `<repo>/.claude/worktrees/<name>` on branch `worktree-<name>`. Aliases (`wt`, `wtl`, `wtd`, `wtc`, `treview`, `tship`, `tsetup`) live in `zshrc/mac/.zshrc`. See `WORKTREES.md` for the handbook. xlaude was used previously but uninstalled — its state lived at `~/Library/Application Support/com.xuanwo.xlaude/` (also removed).
- **tpm** — `mac-install.sh` clones `tmux-plugins/tpm` into `~/.tmux/plugins/tpm` on first run. After install, run `prefix + I` inside tmux to fetch plugins (`tmux-sensible`, `tmux-yank`).
