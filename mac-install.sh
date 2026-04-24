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

# Ghostty
rm -rf $HOME/.config/ghostty
ln -sf $DOTFILES/ghostty $HOME/.config/ghostty

# btop
rm -rf $HOME/.config/btop
ln -sf $DOTFILES/btop $HOME/.config/btop

# newsboat
rm -rf $HOME/.config/newsboat
ln -sf $DOTFILES/newsboat $HOME/.config/newsboat

# matterhorn
rm -rf $HOME/.config/matterhorn
ln -sf $DOTFILES/matterhorn $HOME/.config/matterhorn

echo "dotfiles2026 symlinks installed"

if command -v brew >/dev/null 2>&1; then
  UNWANTED_CASKS="aerospace raycast hiddenbar firefox@nightly ungoogled-chromium vivaldi arc spotify orbstack zoom"
  for c in $UNWANTED_CASKS; do
    if brew list --cask "$c" >/dev/null 2>&1; then
      echo "Removing cask: $c"
      brew uninstall --cask --zap "$c"
    fi
  done

  for f in sketchybar starship yazi zoxide ical-buddy ffmpegthumbnailer poppler; do
    if brew list "$f" >/dev/null 2>&1; then
      brew services stop "$f" 2>/dev/null || true
      echo "Removing formula: $f"
      brew uninstall --ignore-dependencies "$f"
    fi
  done

  rm -rf $HOME/.config/aerospace $HOME/.config/sketchybar $HOME/.config/yazi
  rm -f  $HOME/.config/starship.toml $HOME/.config/theme-family

  for app in Moom.app Cyberduck.app Chromium.app; do
    if [ -d "/Applications/$app" ]; then
      echo "Trashing /Applications/$app"
      osascript -e "tell application \"Finder\" to delete POSIX file \"/Applications/$app\"" >/dev/null 2>&1 || true
    fi
  done

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
echo "  2. Re-bind Cmd+Space to Spotlight in System Settings > Keyboard Shortcuts"
echo "  3. Restart your terminal or run: source ~/.zshrc"
echo "  4. Open nvim - it will auto-install plugins on first run"
