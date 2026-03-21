# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a cross-platform dotfiles repository supporting macOS (primary). The repository uses a symlink-based installation system.

## Key Components

- **Platform-specific install scripts**: `mac-install.sh` - creates symlinks to configuration files in user's home directory
- **ZSH configurations**: Platform-specific zsh configs in `zshrc/mac/`
- **Neovim configuration**: LazyVim-based setup in `nvim/` directory with Catppuccin Macchiato (dark) / Latte (light)
- **Terminal configurations**:
  - Tmux config with Catppuccin Macchiato/Latte status bar
  - Ghostty terminal configuration with Catppuccin Macchiato/Latte
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
- Catppuccin theme (Macchiato dark / Latte light) is used across Neovim, tmux, and Ghostty
- Private configurations (like .kube) are expected in a separate `dotfiles-private` repository

## Theme

Dark mode uses Catppuccin Macchiato, light mode uses Catppuccin Latte (auto-switches based on OS):
- Neovim: `catppuccin-macchiato` / `catppuccin-latte` — custom colorschemes in `nvim/colors/`, auto-switches on focus
- Ghostty: `catppuccin-macchiato` / `catppuccin-latte` — custom themes in `ghostty/themes/`
- tmux: Catppuccin Macchiato/Latte status bar colors
- delta (git): `syntax-theme = Catppuccin Macchiato`
- bat: `BAT_THEME="Catppuccin Macchiato"`
- btop: `catppuccin_macchiato`
- newsboat: Catppuccin colors
