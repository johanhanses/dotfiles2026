# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a cross-platform dotfiles repository supporting macOS (primary). The repository uses a symlink-based installation system.

## Key Components

- **Platform-specific install scripts**: `mac-install.sh` - creates symlinks to configuration files in user's home directory
- **ZSH configurations**: Platform-specific zsh configs in `zshrc/mac/`
- **Neovim configuration**: LazyVim-based setup in `nvim/` directory with GitHub theme
- **Terminal configurations**:
  - Tmux config with GitHub Light theme status bar
  - Ghostty terminal configuration with GitHub theme
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
- GitHub theme is used across all applications (Neovim, tmux, Ghostty, delta, bat)
- Private configurations (like .kube) are expected in a separate `dotfiles-private` repository

## Theme

All applications use the GitHub Light/Dark theme:
- Neovim: `github_light` / `github_dark_dimmed` (auto-switches based on OS)
- Ghostty: `GitHub Light Default` / `GitHub Dark Dimmed`
- tmux: Custom GitHub Light status bar colors
- delta (git): `syntax-theme = GitHub`, `light = true`
- bat: `BAT_THEME="GitHub"`
