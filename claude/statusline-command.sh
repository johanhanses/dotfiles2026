#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

user=$(whoami)
host=$(hostname -s)
dir=$(basename "$cwd")

# Git branch (skip optional lock)
git_branch=""
if git_branch_raw=$(git -C "$cwd" -c gc.auto=0 symbolic-ref --short HEAD 2>/dev/null); then
  git_branch="$git_branch_raw"
fi

# Git status indicators
git_status=""
if [ -n "$git_branch" ]; then
  if [ -n "$(git -C "$cwd" -c gc.auto=0 status --porcelain 2>/dev/null)" ]; then
    git_status="*"
  fi
fi

# Build prompt parts
printf "\033[34m%s@%s\033[0m " "$user" "$host"
printf "\033[34m%s\033[0m" "$dir"

if [ -n "$git_branch" ]; then
  printf " \033[90m%s\033[0m" "$git_branch"
fi

if [ -n "$git_status" ]; then
  printf "\033[38;5;218m(%s)\033[0m" "$git_status"
fi

if [ -n "$model" ]; then
  printf " \033[90m[%s]\033[0m" "$model"
fi

if [ -n "$used" ]; then
  printf " \033[33m%s%%\033[0m" "$used"
fi

printf "\n"
