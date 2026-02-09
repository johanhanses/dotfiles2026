# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a cross-platform dotfiles repository supporting macOS (primary). The repository uses a symlink-based installation system.

## Key Components

- **Platform-specific install scripts**: `mac-install.sh` - creates symlinks to configuration files in user's home directory
- **ZSH configurations**: Platform-specific zsh configs in `zshrc/mac/`
- **Neovim configuration**: LazyVim-based setup in `nvim/` directory with Night Owl (dark) / Rosé Pine Dawn (light)
- **Terminal configurations**:
  - Tmux config with Night Owl (dark) / Rosé Pine Dawn (light) status bar
  - Ghostty terminal configuration with Night Owl (dark) / Rosé Pine Dawn (light)
- **System monitoring**: btop configuration
- **RSS reader**: newsboat configuration

## Common Commands

**Installation (run from repository root):**
```bash
# macOS
./mac-install.sh
```

**Development IDE layout (tmux):**
```bash
# Creates a multi-pane tmux layout for development
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
- Night Owl (dark) / Rosé Pine Dawn (light) theme is used across Neovim, tmux, and Ghostty
- Private configurations (like .kube) are expected in a separate `dotfiles-private` repository

## Theme

Dark mode uses Night Owl, light mode uses Rosé Pine Dawn (auto-switches based on OS):
- Neovim: `night-owl` (dark) / `rose-pine` Dawn (light) — auto-switches on focus
- Ghostty: `Night Owl` (dark) / `Rose Pine Dawn` (light)
- tmux: Night Owl (dark) / Rosé Pine Dawn (light) status bar colors
- delta (git): `syntax-theme = OneHalfDark`
- bat: `BAT_THEME="OneHalfDark"`
- btop: `onedark`
- newsboat: One Dark inspired colors
