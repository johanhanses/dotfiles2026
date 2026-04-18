#!/usr/bin/env sh

DOTFILES="$(pwd)"
DOTFILES_PRIVATE="$HOME/Repos/github.com/johanhanses/dotfiles-private"

# Zsh
ln -sf $DOTFILES/zshrc/mac/.zshrc $HOME/.zshrc

# Neovim
rm -rf $HOME/.config/nvim
ln -sf $DOTFILES/nvim $HOME/.config/nvim

# Tmux
rm -rf $HOME/.config/tmux
ln -sf $DOTFILES/tmux $HOME/.config/tmux

# Git
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global

# .kube (from private repo)
if [ -d "$DOTFILES_PRIVATE/.kube" ]; then
  rm -rf $HOME/.kube
  ln -sf $DOTFILES_PRIVATE/.kube $HOME/.kube
fi

# btop
rm -rf $HOME/.config/btop
ln -sf $DOTFILES/btop $HOME/.config/btop

# newsboat
rm -rf $HOME/.config/newsboat
ln -sf $DOTFILES/newsboat $HOME/.config/newsboat

# ghostty
rm -rf $HOME/.config/ghostty
ln -sf $DOTFILES/ghostty $HOME/.config/ghostty

# matterhorn
rm -rf $HOME/.config/matterhorn
ln -sf $DOTFILES/matterhorn $HOME/.config/matterhorn

# aerospace
mkdir -p $HOME/.config/aerospace
ln -sf $DOTFILES/aerospace/aerospace.toml $HOME/.config/aerospace/aerospace.toml

# sketchybar
rm -rf $HOME/.config/sketchybar
ln -sf $DOTFILES/sketchybar $HOME/.config/sketchybar

# yazi
rm -rf $HOME/.config/yazi
ln -sf $DOTFILES/yazi $HOME/.config/yazi

# starship
ln -sf $DOTFILES/starship.toml $HOME/.config/starship.toml

echo "dotfiles2026 symlinks installed"

if command -v brew >/dev/null 2>&1; then
  printf "\nRun 'brew bundle --file=%s/Brewfile' to install packages? [y/N] " "$DOTFILES"
  read -r reply
  case "$reply" in
    [yY]|[yY][eE][sS])
      brew bundle --file="$DOTFILES/Brewfile"
      ;;
    *)
      echo "Skipped brew bundle. Run it later: brew bundle --file=$DOTFILES/Brewfile"
      ;;
  esac
else
  echo "Homebrew not found. Install it first: https://brew.sh"
fi

echo ""
echo "Next steps:"
echo "  1. Run ./scripts/macos-defaults.sh to apply macOS system tweaks"
echo "  2. Unbind Cmd+Space in System Settings > Keyboard Shortcuts > Spotlight"
echo "  3. Launch Aerospace + Raycast once so they request accessibility permissions"
echo "  4. Restart your terminal or run: source ~/.zshrc"
echo "  5. Open nvim - it will auto-install plugins on first run"
echo "  6. Install xlaude: cargo install xlaude"
echo "  7. See KEYBINDINGS.md for the full shortcut reference"
