# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a cross-platform dotfiles repository supporting macOS (primary). The repository uses a symlink-based installation system.

## Key Components

- **Platform-specific install scripts**: `mac-install.sh` - creates symlinks to configuration files in user's home directory
- **ZSH configurations**: Platform-specific zsh configs in `zshrc/mac/`
- **Neovim configuration**: LazyVim-based setup in `nvim/` directory with Conductor Stone (dark/light)
- **Terminal configurations**:
  - Tmux config with Conductor Stone (dark/light) status bar
  - Ghostty terminal configuration with Conductor Stone (dark/light)
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
- Conductor Stone theme (dark/light) is used across Neovim, tmux, and Ghostty — inspired by conductor.build's warm stone palette
- Private configurations (like .kube) are expected in a separate `dotfiles-private` repository

## Theme

Dark mode uses Conductor Stone Dark, light mode uses Conductor Stone Light (auto-switches based on OS). Inspired by the conductor.build warm stone/earth palette with amber accents:
- Neovim: `conductor-dark` / `conductor-light` — custom colorschemes in `nvim/colors/`, auto-switches on focus
- Ghostty: `conductor-dark` / `conductor-light` — custom themes in `ghostty/themes/`
- tmux: Conductor Stone dark/light status bar colors
- delta (git): `syntax-theme = gruvbox-dark`
- bat: `BAT_THEME="gruvbox-dark"`
- btop: `gruvbox_dark`
- newsboat: Conductor Stone warm colors
