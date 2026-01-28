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

echo "dotfiles2026 installed!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open nvim - it will auto-install plugins on first run"
echo "  3. Start tmux and verify the appearance"
echo "  4. Install xlaude: cargo install xlaude"
