# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a cross-platform dotfiles repository supporting macOS (primary). The repository uses a symlink-based installation system.

## Key Components

- **Platform-specific install scripts**: `mac-install.sh` - creates symlinks to configuration files in user's home directory
- **ZSH configurations**: Platform-specific zsh configs in `zshrc/mac/`
- **Neovim configuration**: LazyVim-based setup in `nvim/` directory with One Dark theme
- **Terminal configurations**:
  - Tmux config with One Dark theme status bar
  - Ghostty terminal configuration with One Half Dark/Light theme
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
- One Dark/One Half theme is used across all applications (Neovim, tmux, Ghostty, delta, bat)
- Private configurations (like .kube) are expected in a separate `dotfiles-private` repository

## Theme

All applications use the One Dark/One Half theme:
- Neovim: `onedark` with `light` / `dark` style (auto-switches based on OS)
- Ghostty: `OneHalfLight` / `OneHalfDark`
- tmux: Custom One Dark status bar colors
- delta (git): `syntax-theme = OneHalfDark`
- bat: `BAT_THEME="OneHalfDark"`
- btop: `onedark`
- newsboat: One Dark inspired colors
