export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace

setopt share_history
setopt append_history
setopt inc_append_history

# Enable completions
autoload -Uz compinit && compinit

# Zsh plugins (install with brew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unset zle_bracketed_paste

export BAT_THEME="ansi"
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

export XDG_CONFIG_HOME="$HOME/.config"
export REPOS="$HOME/Repos"
export GITUSER="johanhanses"
export GHREPOS="$HOME/Repos/github.com/johanhanses"
export DOTFILES="$GHREPOS/dotfiles2026"
export SCRIPTS="$DOTFILES/scripts"
export SECOND_BRAIN="$GHREPOS/zettelkasten"
export WORK_DIR="$REPOS/github.com/Digital-Tvilling"
export LKAB_DIR="$WORK_DIR/.lkab"
export ONPREM_CONFIG_DIR="$LKAB_DIR/on-prem/config"
export ONPREM_CERT_DIR="$LKAB_DIR/on-prem/cert"
export PATH="$XDG_CONFIG_HOME/scripts:$PATH:/home/johanhanses/.local/bin"
export PATH="$PATH:$DOTFILES/scripts"
export PATH="$PATH:$SECOND_BRAIN"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@22/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@22/include"

export AWS_PROFILE=saml

KUBECONFIG=~/.kube/config

# Prompt: apple logo + folder + full path + git branch (bold green); $ on next line
# Requires a Nerd Font in Terminal.app (e.g. MesloLGS Nerd Font, GeistMono Nerd Font)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT=$'%B%F{green}\uF8FF  \uF07B  %~${vcs_info_msg_0_}%f%b\n$ '

# mise (runtime version manager)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# fzf + fd
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# xlaude worktree helpers
xcd() { cd "$(xlaude dir "$@")"; }
xv() { nvim "$(xlaude dir "$@")"; }
alias xl='xlaude list'
alias xc='xlaude create'
alias xo='xlaude open'
alias xd='xlaude delete'

# Directory aliases
alias repos="cd $REPOS"
alias ghrepos="cd $GHREPOS"
alias dot="cd $DOTFILES"
alias scripts="cd $DOTFILES/scripts"
alias rwdot="cd $REPOS/github.com/rwxrob/dot"
alias rob="cd $REPOS/github.com/rwxrob"
alias dt="cd $REPOS/github.com/Digital-Tvilling"
alias plan="cd $REPOS/github.com/Digital-Tvilling/DT-Frontend-planning"
alias rtm="cd $REPOS/github.com/Digital-Tvilling/dt-apps"
alias deploy="cd $REPOS/github.com/Digital-Tvilling/deployment-configuration"
alias backend="cd $REPOS/github.com/Digital-Tvilling/deployment-configuration/external/localhost"
alias dti="cd $REPOS/github.com/Digital-Tvilling/dti"
alias dev="cd $REPOS/github.com/Digital-Tvilling/digital-tvilling-dev"
alias prod="cd $REPOS/github.com/Digital-Tvilling/digital-tvilling-prod"
alias home="cd $REPOS/github.com/johanhanses/johanhanses.com/"
alias sb="cd $SECOND_BRAIN"
alias config="cd $XDG_CONFIG_HOME"

# Tool aliases
alias cat="bat --style=plain"
alias fast="fast -u --single-line"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"

alias neofetch="fastfetch"
alias photos="npx --yes icloudpd --directory ~/icloud-photos --username johanhanses@gmail.com --watch-with-interval 3600"
alias nv="nvim"
alias c="clear"
alias cl="claude"
alias ca="cursor-agent"

# npm aliases
alias n="npm"
alias nr="npm run"
alias ns="npm start"

# ls/eza aliases
alias ls="ls --color=auto"
alias ll="eza -l -a -a -g --group-directories-first --show-symlinks --icons=always"
alias l="eza -l -g --group-directories-first --show-symlinks --icons=always"
alias la="ls -lathr"
alias lg="lazygit"

alias tree="eza --tree"
alias e="exit"

# git aliases
alias gm="git checkout main && git pull"
alias gd="git diff"
alias gp="git push"
alias ga="git add ."
alias gs="git status"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias wip="git commit -m \"wip\" --no-verify"

# kubectl aliases
alias k="kubectl"
alias kc="kubectx"

# tmux aliases
alias t="tmux"
alias tk="tmux kill-server"
alias tl="tmux ls"
alias ta="tmux a"

alias zj="zellij"

# docker aliases
alias d="docker"
alias dc="docker compose"

# source zshrc
alias szr="source ~/.zshrc"
