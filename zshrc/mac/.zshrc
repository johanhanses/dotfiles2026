export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace

setopt share_history
setopt append_history
setopt inc_append_history

# Enable completions
fpath=(~/.zfunc $fpath)
autoload -Uz compinit && compinit

# Zsh plugins (install with brew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Force emacs-style line editing (zsh defaults to vi when $EDITOR contains "vi")
bindkey -e

unset zle_bracketed_paste

if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
  export BAT_THEME="OneHalfDark"
else
  export BAT_THEME="OneHalfLight"
fi
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

export KUBECONFIG=~/.kube/config

# Prompt: apple logo + folder + full path + git branch, Atom One accents.
# Uses named ANSI colors so it follows the terminal palette (light/dark auto).
# Requires a Nerd Font (e.g. JetBrainsMono Nerd Font).
autoload -Uz vcs_info
update_terminal_cwd() {}
precmd() { vcs_info; printf '\e[2 q'; print -Pn '\e]2;%1~\a' }
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
setopt PROMPT_SUBST
PROMPT=$'%B%F{red}\uF179  %F{yellow}\uF07B  %F{blue}%1~%f${vcs_info_msg_0_}%b\n%F{cyan}$%f '

# fzf + fd
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Claude-native worktree workflow.
# Worktrees land at <repo>/.claude/worktrees/<name>, branch = <name>.
# tsetup is invoked automatically after creation. See WORKTREES.md.

# _wt_main — print the main worktree's path (works from inside any worktree).
_wt_main() {
  git worktree list --porcelain 2>/dev/null | awk '/^worktree / { print $2; exit }'
}

# _wt_session — tmux session name = basename of the repo's main worktree path.
# Sanitized: tmux session names can't contain '.' or ':'.
_wt_session() {
  local main_root="${1:-$(_wt_main)}"
  [[ -z "$main_root" ]] && return 1
  printf '%s' "${main_root:t}" | tr '.:' '__'
}

# _wt_ensure_session <session> <main_root>
# Make sure the per-repo session exists; first window is the main worktree.
_wt_ensure_session() {
  local sess="$1" main_root="$2"
  tmux has-session -t="$sess" 2>/dev/null && return 0
  tmux new-session -d -s "$sess" -n main -c "$main_root"
}

# _wt_open <name> [base] — internal: create-or-attach worktree, run tsetup,
# launch claude in a window of the per-repo session, switch focus to it.
_wt_open() {
  local name="$1" base="${2:-main}"
  local main_root wt_path sess win
  main_root=$(_wt_main)
  [[ -z "$main_root" ]] && { echo "wt: not inside a git repo"; return 1; }
  wt_path="$main_root/.claude/worktrees/$name"
  sess=$(_wt_session "$main_root")
  win="${name:t}"

  if [[ ! -d "$wt_path" ]]; then
    if git -C "$main_root" show-ref --verify --quiet "refs/heads/$name"; then
      git -C "$main_root" worktree add "$wt_path" "$name" || return 1
    else
      git -C "$main_root" worktree add -b "$name" "$wt_path" "$base" || return 1
    fi
  fi

  ( cd "$wt_path" && tsetup ) || echo "wt: tsetup returned non-zero (continuing)"

  _wt_ensure_session "$sess" "$main_root"
  if ! tmux list-windows -t "$sess" -F '#W' 2>/dev/null | grep -Fxq "$win"; then
    tmux new-window -t "${sess}:" -n "$win" -c "$wt_path" "exec claude --permission-mode plan --dangerously-skip-permissions"
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "${sess}:${win}"
  else
    # Bare shell (no tmux attached): attach to the per-repo session, landing on
    # the worktree window. `exec` so the shell is replaced — detaching exits clean.
    tmux select-window -t "${sess}:${win}"
    exec tmux attach -t "$sess"
  fi
}

# wt <name> [base] — new feature worktree from <base> (default main).
wt() {
  local name="${1:?usage: wt <name> [base-ref]}"
  local base="${2:-main}"
  _wt_open "$name" "$base"
}

# wtp <pr> — new worktree from an existing remote PR (number or URL).
wtp() {
  local pr="${1:?usage: wtp <pr-number-or-url>}"
  local main_root pr_num head_ref
  main_root=$(_wt_main)
  [[ -z "$main_root" ]] && { echo "wtp: not inside a git repo"; return 1; }
  if ! command -v gh >/dev/null || ! command -v jq >/dev/null; then
    echo "wtp: needs gh + jq"; return 1
  fi
  pr_num=$(gh pr view "$pr" --json number -q .number 2>/dev/null)
  head_ref=$(gh pr view "$pr" --json headRefName -q .headRefName 2>/dev/null)
  if [[ -z "$pr_num" || -z "$head_ref" ]]; then
    echo "wtp: failed to resolve PR '$pr'"; return 1
  fi
  echo "wtp: fetching PR #$pr_num ($head_ref)…"
  git -C "$main_root" fetch origin "refs/pull/$pr_num/head:$head_ref" 2>&1 | tail -3
  _wt_open "$head_ref" "$head_ref"
}

# wtl — list git worktrees (source of truth)
alias wtl='git worktree list'

# wta [-f] <name> — archive: remove worktree dir, keep branch.
# -f/--force: pass through to git worktree remove (drops untracked/modified files).
wta() {
  local force=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--force) force="--force"; shift ;;
      *) break ;;
    esac
  done
  local name="${1:?usage: wta [-f] <name>}"
  local main_root wt_path
  main_root=$(_wt_main)
  [[ -z "$main_root" ]] && { echo "wta: not inside a git repo"; return 1; }
  wt_path="$main_root/.claude/worktrees/$name"
  case "$(pwd)/" in "$wt_path"/*) cd "$main_root" ;; esac
  git -C "$main_root" worktree remove ${force:+$force} "$wt_path"
}

# wtd [-f] <name> — delete: remove worktree dir + branch (post-merge cleanup).
# -f/--force: pass through to git worktree remove AND use git branch -D.
wtd() {
  local force="" branch_flag="-d"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--force) force="--force"; branch_flag="-D"; shift ;;
      *) break ;;
    esac
  done
  local name="${1:?usage: wtd [-f] <name>}"
  local main_root wt_path
  main_root=$(_wt_main)
  [[ -z "$main_root" ]] && { echo "wtd: not inside a git repo"; return 1; }
  wt_path="$main_root/.claude/worktrees/$name"
  case "$(pwd)/" in "$wt_path"/*) cd "$main_root" ;; esac
  git -C "$main_root" worktree remove ${force:+$force} "$wt_path" || return 1
  git -C "$main_root" branch "$branch_flag" "$name" 2>/dev/null || \
    echo "wtd: branch '$name' had unmerged commits; rerun 'wtd -f $name' to force-delete it"
}

# wtc — fzf-pick an existing worktree; switches to its window in the per-repo
# session (creating the session/window/tmux server if needed).
wtc() {
  local target
  target=$(git worktree list | fzf --height=40% --prompt='worktree> ') || return
  target=${target%% *}
  [[ -z "$target" ]] && return
  local main_root sess win
  main_root=$(_wt_main)
  sess=$(_wt_session "$main_root")
  win="${target:t}"
  _wt_ensure_session "$sess" "$main_root"
  if ! tmux list-windows -t "$sess" -F '#W' 2>/dev/null | grep -Fxq "$win"; then
    tmux new-window -t "${sess}:" -n "$win" -c "$target"
  fi
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "${sess}:${win}"
  else
    tmux select-window -t "${sess}:${win}"
    exec tmux attach -t "$sess"
  fi
}

# wts — sesh popup from any shell (cross-repo session switcher). Same picker as
# tmux's <prefix>+T binding.
alias wts='sesh connect "$(sesh list -tcd | sort | fzf --height=40% --reverse --no-sort --prompt "sesh> ")"'

# wtg — global worktree picker. Aggregates `git worktree list` across WT_REPOS
# into one fzf picker, then opens (or switches to) the right per-repo tmux
# session+window. Works from any shell, doesn't need to be inside a repo.
# Override WT_REPOS (colon-separated paths) to point at different roots.
wtg() {
  local repos="${WT_REPOS:-$HOME/Repos/github.com/johanhanses/dotfiles2026:$HOME/Repos/github.com/johanhanses/zettelkasten:$HOME/Repos/github.com/Digital-Tvilling/dt-apps:$HOME/Repos/github.com/Digital-Tvilling/digital-tvilling-dev:$HOME/Repos/github.com/Digital-Tvilling/digital-tvilling-prod:$HOME/Repos/github.com/Digital-Tvilling/obsidian}"
  local root sess path entries=() line
  for root in ${(s/:/)repos}; do
    [[ -e "$root/.git" ]] || continue
    sess="${root:t}"
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      entries+=("${(r:22:)sess}  ${line}")
    done < <(git -C "$root" worktree list 2>/dev/null)
  done
  [[ ${#entries[@]} -eq 0 ]] && { echo "wtg: no worktrees in WT_REPOS"; return 1; }

  local pick
  pick=$(printf '%s\n' "${entries[@]}" | fzf --height=60% --reverse --prompt='wtg> ') || return
  # Row is "<sess-padded>  <path>  <sha>  [<branch>]" — field 2 = path.
  path=$(awk '{print $2}' <<< "$pick")
  [[ -z "$path" || ! -d "$path" ]] && { echo "wtg: bad pick: $pick"; return 1; }

  local main_root sess_real win
  main_root=$(git -C "$path" worktree list --porcelain 2>/dev/null | awk '/^worktree / { print $2; exit }')
  [[ -z "$main_root" ]] && main_root="$path"
  sess_real=$(_wt_session "$main_root")
  win="${path:t}"

  _wt_ensure_session "$sess_real" "$main_root"
  if ! tmux list-windows -t "$sess_real" -F '#W' 2>/dev/null | grep -Fxq "$win"; then
    tmux new-window -t "${sess_real}:" -n "$win" -c "$path"
  fi
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "${sess_real}:${win}"
  else
    tmux select-window -t "${sess_real}:${win}"
    exec tmux attach -t "$sess_real"
  fi
}

treview() {
  [[ -z "$TMUX" ]] && { echo "treview needs to run inside tmux"; return 1; }
  local base="${1:-main}"
  tmux split-window -h -p 40 "git diff $base...HEAD; \$SHELL"
  tmux split-window -v -p 50 "\$SHELL"
}
tship() {
  git status --short
  read "ok?Open PR with 'gh pr create --fill'? [y/N] "
  [[ "$ok" =~ ^[Yy] ]] || return 1
  gh pr create --fill || return 1
  echo "PR open. When merged, run: wtd <name>"
}
# tsetup — bootstrap a fresh worktree.
#   1) conductor.json scripts.setup with CONDUCTOR_ROOT_PATH=main worktree
#   2) executable .conductor/setup or .wt/setup
#   3) smart fallback: symlink .env files from main worktree + run package install
#      + init git submodules (if .gitmodules present)
tsetup() {
  if [[ -f conductor.json ]] && command -v jq >/dev/null; then
    local setup_cmd
    setup_cmd=$(jq -r '.scripts.setup // empty' conductor.json)
    if [[ -n "$setup_cmd" ]]; then
      local main_wt
      main_wt=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / { print $2; exit }')
      [[ -z "$main_wt" ]] && main_wt="$(pwd)"
      echo "tsetup: conductor.json scripts.setup (CONDUCTOR_ROOT_PATH=$main_wt)"
      CONDUCTOR_ROOT_PATH="$main_wt" eval "$setup_cmd"
      return $?
    fi
  fi
  local script
  for script in .conductor/setup .wt/setup; do
    if [[ -x "$script" ]]; then
      echo "tsetup: $script"
      "$script"
      return $?
    fi
  done
  # Smart fallback: symlink .env files + run package install.
  local main_wt cwd env_count=0
  main_wt=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / { print $2; exit }')
  cwd=$(pwd)
  if [[ -n "$main_wt" && "$main_wt" != "$cwd" ]]; then
    while IFS= read -r env_file; do
      local rel="${env_file#$main_wt/}"
      local dest="$cwd/$rel"
      [[ -e "$dest" ]] && continue
      mkdir -p "$(dirname "$dest")"
      ln -sf "$env_file" "$dest" && env_count=$((env_count+1))
    done < <(find "$main_wt" -maxdepth 5 \( -name '.env' -o -name '.env.local' -o -name '.env.development' \) \
             -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null)
    [[ $env_count -gt 0 ]] && echo "tsetup: linked $env_count .env file(s) from main worktree"
  fi
  if [[ -f package.json ]]; then
    if [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null; then
      echo "tsetup: pnpm install"; pnpm install
    elif [[ -f yarn.lock ]] && command -v yarn >/dev/null; then
      echo "tsetup: yarn install"; yarn install
    elif command -v npm >/dev/null; then
      echo "tsetup: npm install"; npm install
    fi
  fi
  if [[ -f .gitmodules ]]; then
    echo "tsetup: git submodule update --init --recursive"
    git submodule update --init --recursive
  fi
}

# Directory aliases
alias repos="cd $REPOS"
alias ghrepos="cd $GHREPOS"
alias dot="cd $DOTFILES"
alias scripts="cd $DOTFILES/scripts"
alias rwdot="cd $REPOS/github.com/rwxrob/dot"
alias rob="cd $REPOS/github.com/rwxrob"
alias dt="cd $REPOS/github.com/Digital-Tvilling"
alias plan="cd $REPOS/github.com/Digital-Tvilling/DT-Frontend-planning"
alias lkab="cd $REPOS/github.com/Digital-Tvilling/digitaltvilling"
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
alias cl="claude --dangerously-skip-permissions"
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
alias t="tmux new -A -s default"
alias tk="tmux kill-server"
alias tl="tmux ls"
alias ta="tmux a"

alias zj="zellij"

# docker aliases
alias d="docker"
alias dc="docker compose"

# source zshrc
alias szr="source ~/.zshrc"
