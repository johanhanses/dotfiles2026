# Keybindings Reference

A single-page reference for every shortcut in this dotfiles setup. Each tool's config file is the source of truth — this document cross-references them so you can find anything fast.

## How to read this

| Symbol | Key        |
|--------|------------|
| `⌘`    | Cmd        |
| `⌥`    | Alt/Option |
| `⌃`    | Ctrl       |
| `⇧`    | Shift      |
| `␣`    | Space      |

For tmux, `<prefix>` means `Ctrl+a` unless rebound.

---

## Window Manager — Aerospace

Aerospace is a tiling window manager. Windows snap into a tree; you navigate with hjkl and switch between 9 workspaces with `Alt+1..9`. Native macOS spaces are disabled (`mru-spaces = false`). macOS full-screen mode no longer creates a space — apps share the current workspace.

**Layouts**: `tiles` (default horizontal/vertical split) and `accordion` (stacked). Toggle with `Alt+o` (tiles) or `Alt+,` (accordion).

### Focus

| Keys              | Action               |
|-------------------|----------------------|
| `Alt+h`           | Focus window left    |
| `Alt+j`           | Focus window down    |
| `Alt+k`           | Focus window up      |
| `Alt+l`           | Focus window right   |
| `Alt+Tab`         | Jump to last workspace |

### Move windows

| Keys                    | Action               |
|-------------------------|----------------------|
| `Alt+Shift+h/j/k/l`     | Move window in direction |
| `Alt+Shift+1..9`        | Move window to workspace 1–9 (pairs with `Alt+1..9` switch) |

### Resize

| Keys                | Action        |
|---------------------|---------------|
| `Alt+Ctrl+h` / `j`  | Shrink        |
| `Alt+Ctrl+l` / `k`  | Grow          |

### Workspaces & layouts

| Keys                | Action                           |
|---------------------|----------------------------------|
| `Alt+1..9`          | Switch to workspace 1–9          |
| `Alt+o`             | Toggle tiles layout (horizontal/vertical) |
| `Alt+,`             | Toggle accordion layout          |
| `Alt+f`             | Fullscreen toggle                |
| `Alt+Shift+␣`       | Floating ↔ tiling toggle         |

### Service mode (Alt+Shift+Enter)

Enter service mode then press:

| Key            | Action                       |
|----------------|------------------------------|
| `Esc`          | Reload config, exit mode     |
| `r`            | Flatten workspace tree       |
| `f`            | Toggle floating/tiling       |
| `Backspace`    | Close all windows but current |
| `Alt+Shift+h/j/k/l` | Join with neighbor window |

**Config**: `aerospace/aerospace.toml`

---

## Launcher — Raycast

Raycast replaces Spotlight. Disable Spotlight's `Cmd+Space` in System Settings first.

| Keys               | Action                              |
|--------------------|-------------------------------------|
| `Cmd+␣`            | Open Raycast                        |
| `Cmd+Shift+V`      | Clipboard history (extension default) |

Window management extension is **not used** — Aerospace owns that.

**Setup**: `RAYCAST-SETUP.md`

---

## Status Bar — SketchyBar

No user keybindings. Click workspace indicators to switch. Contents (left → right):

- **Workspaces 1–9** — active one highlighted blue
- **Front app name** — current focused app

Right side (icons left→right, some conditional):

- **Music** — Apple Music track (hidden when not playing)
- **Mail** — Mail.app inbox unread (hidden at 0 or when Mail.app is closed; requires Automation permission)
- **Calendar** — next event today (requires `icalBuddy` + Calendar permission)
- **Weather** — condition + temp via wttr.in (IP-based location)
- **Tailscale** — VPN status (green=on, red=off, dim=CLI missing)
- **WiFi** — icon-only; blue=online, dim=offline
- **CPU** — usage %, color-coded (yellow ≥50%, red ≥80%) — hidden on built-in display
- **Memory** — used/total GB, color-coded (yellow ≥65%, red ≥85%) — hidden on built-in display
- **Volume** — %, speaker glyph — hidden on built-in display
- **Battery** — %, charge glyph (color by level; green while charging)
- **Clock** — weekday + date + time

**Per-monitor trim**: on the built-in MacBook display, CPU/Memory/Volume are hidden automatically to reduce clutter. External monitors show the full set. Switching is reactive — the trim runs on Aerospace workspace change (which fires on monitor change).

Nerd Font glyphs require Geist Mono Nerd Font to render.

| Shell command                      | Action             |
|------------------------------------|--------------------|
| `sketchybar --reload`              | Reload bar config  |
| `brew services restart sketchybar` | Full restart       |

**Config**: `sketchybar/sketchybarrc` + `sketchybar/plugins/*.sh`

---

## Terminal — Ghostty

Geist Mono Nerd Font, Tokyo Night, hidden title bar, 92% opacity with blur.

| Keys               | Action                       |
|--------------------|------------------------------|
| `Cmd+D`            | Split right                  |
| `Cmd+Shift+D`      | Split down                   |
| `Cmd+Shift+H`      | Focus previous split         |
| `Cmd+Shift+L`      | Focus next split             |
| `Cmd+Shift+Enter`  | Toggle split zoom            |
| `Cmd+W`            | Close surface                |
| `Cmd+T`            | New tab                      |
| `Cmd+N`            | New window                   |
| `Cmd+Shift+,`      | Reload config                |
| `Cmd+K`            | Clear screen (default)       |
| `Cmd++` / `Cmd+-`  | Font size up/down (default)  |

**Config**: `ghostty/config`

---

## Editor — Neovim (LazyVim)

Leader is `Space`. This lists the non-default keys used regularly; LazyVim's full keymap is discoverable via `Space` (which-key).

### Core

| Keys           | Action                         |
|----------------|--------------------------------|
| `Space`        | Leader (which-key menu)        |
| `Space+␣`      | Find file (root dir)           |
| `Space+,`      | Switch buffer                  |
| `Space+/`      | Grep (root)                    |
| `Space+:`      | Command history                |
| `Space+e`      | File tree (Neo-tree)           |

### Find

| Keys           | Action                    |
|----------------|---------------------------|
| `Space+ff`     | Find file                 |
| `Space+fg`     | Live grep                 |
| `Space+fb`     | Find buffer               |
| `Space+fr`     | Recent files              |
| `Space+sg`     | Search grep               |

### Git

| Keys           | Action                         |
|----------------|--------------------------------|
| `Space+gg`     | Open LazyGit                   |
| `Space+gb`     | Git blame line                 |
| `]h` / `[h`    | Next/previous git hunk         |

### Claude Code (ClaudeCode plugin)

| Keys           | Action                    |
|----------------|---------------------------|
| `Space+aa`     | Toggle Claude Code         |

### No-neck-pain

| Keys           | Action                    |
|----------------|---------------------------|
| `Space+np`     | Toggle centered layout    |

### Window/tmux navigation

| Keys           | Action                              |
|----------------|-------------------------------------|
| `Ctrl+h/j/k/l` | Move between panes (shared w/ tmux) |

**Plugin configs**: `nvim/lua/plugins/*.lua`

---

## Multiplexer — tmux

| Keys                  | Action                         |
|-----------------------|--------------------------------|
| `Ctrl+a`              | Prefix                         |
| `<prefix>+r`          | Reload config                  |
| `<prefix>+\|`         | Split horizontally             |
| `<prefix>+-`          | Split vertically               |
| `<prefix>+c`          | New window (in current dir)    |
| `<prefix>+n` / `p`    | Next / previous window         |
| `<prefix>+Ctrl+n/p`   | Alternate next/prev window     |
| `<prefix>+h/j/k/l`    | Select pane (repeatable)       |
| `<prefix>+Ctrl+h/l`   | Previous/next window           |
| `<prefix>+b`          | Toggle status bar              |
| `<prefix>+t`          | Re-sync theme with OS appearance |
| `<prefix>+P`          | Paste from macOS clipboard     |
| `Ctrl+h/j/k/l`        | Seamless nav (tmux ↔ nvim)     |

### Copy mode (vi)

| Keys           | Action                    |
|----------------|---------------------------|
| `v`            | Begin selection           |
| `y` / `Enter`  | Copy to macOS clipboard   |

**Config**: `tmux/tmux.conf`

**Layout script**: `./scripts/ide` spawns a multi-pane dev layout.

---

## File Manager — Yazi

Launch with `y` (shell function — cd's into last directory on exit).

### Navigation

| Keys           | Action                         |
|----------------|--------------------------------|
| `h/j/k/l`      | Left / down / up / right       |
| `Enter`        | Open (nvim for text)           |
| `q`            | Quit without cd                |
| `Q`            | Quit and cd to current dir     |
| `Ctrl+h`       | Toggle hidden files            |
| `!`            | Open shell in current dir      |

### Custom jumps

| Keys     | Action                                  |
|----------|-----------------------------------------|
| `gh`     | `~`                                     |
| `gc`     | `~/.config`                             |
| `gd`     | `~/conductor/workspaces`                |
| `gr`     | `~/Repos/github.com/johanhanses/dotfiles2026` |
| `gD`     | `~/Downloads`                           |
| `gp`     | `~/Pictures`                            |

**Config**: `yazi/yazi.toml`, `yazi/keymap.toml`, `yazi/theme.toml`

---

## System Monitor — btop

| Keys         | Action                    |
|--------------|---------------------------|
| `h/j/k/l`    | Navigate (vim_keys=true)  |
| `Esc`        | Open menu                 |
| `q`          | Quit                      |
| `f`          | Filter processes          |
| `Shift+k`    | Kill process              |
| `+` / `-`    | Speed up / slow down      |
| `r`          | Reverse sort              |

**Config**: `btop/btop.conf`

---

## Shell — zsh + fzf + zoxide

### fzf

| Keys        | Action                       |
|-------------|------------------------------|
| `Ctrl+R`    | Fuzzy search history         |
| `Ctrl+T`    | Fuzzy find file (via fd)     |
| `Alt+C`     | Fuzzy cd into directory      |

### zoxide

| Command        | Action                         |
|----------------|--------------------------------|
| `z <query>`    | Jump to a frecency-ranked dir  |
| `zi`           | Interactive picker             |
| `cd`           | Falls through to zoxide via alias |

### zsh-autosuggestions

| Keys        | Action                    |
|-------------|---------------------------|
| `→`         | Accept full suggestion    |
| `Ctrl+→`    | Accept one word           |

### Yazi helper

| Command | Action                                          |
|---------|-------------------------------------------------|
| `y`     | Launch yazi and cd into last directory on exit  |

**Config**: `zshrc/mac/.zshrc`

---

## Git — shell aliases

| Alias  | Expands to                              |
|--------|-----------------------------------------|
| `gs`   | `git status`                            |
| `gd`   | `git diff`                              |
| `gp`   | `git push`                              |
| `ga`   | `git add .`                             |
| `gc`   | `git checkout`                          |
| `gcb`  | `git checkout -b`                       |
| `gcm`  | `git commit -m`                         |
| `gm`   | `git checkout main && git pull`         |
| `wip`  | `git commit -m "wip" --no-verify`       |
| `lg`   | `lazygit`                               |

### xlaude worktree helpers

| Alias / fn | Action                          |
|------------|---------------------------------|
| `xl`       | `xlaude list`                   |
| `xc`       | `xlaude create`                 |
| `xo`       | `xlaude open`                   |
| `xd`       | `xlaude delete`                 |
| `xcd <ws>` | cd into worktree dir            |
| `xv <ws>`  | open worktree in nvim           |

**Config**: `zshrc/mac/.zshrc`

---

## kubectl / docker / tmux / misc

| Alias | Expands to              |
|-------|-------------------------|
| `k`   | `kubectl`               |
| `kc`  | `kubectx`               |
| `d`   | `docker`                |
| `dc`  | `docker compose`        |
| `t`   | `tmux`                  |
| `ta`  | `tmux a`                |
| `tl`  | `tmux ls`               |
| `tk`  | `tmux kill-server`      |
| `zj`  | `zellij`                |
| `nv`  | `nvim`                  |
| `n`   | `npm`                   |
| `nr`  | `npm run`               |
| `ns`  | `npm start`             |
| `cl`  | `claude`                |
| `ca`  | `cursor-agent`          |
| `szr` | `source ~/.zshrc`       |

---

## RSS — newsboat

| Keys    | Action                       |
|---------|------------------------------|
| `j/k`   | Down / up                    |
| `J/K`   | Next / previous feed         |
| `g/G`   | Top / bottom                 |
| `l`     | Open link                    |
| `h`     | Quit / back                  |
| `r`     | Reload feed                  |
| `R`     | Reload all feeds             |
| `A`     | Mark feed read               |

**Config**: `newsboat/config`

---

## Post-install reminders

- Unbind **Spotlight** `Cmd+␣` in **System Settings → Keyboard → Keyboard Shortcuts**.
- Grant **Aerospace** and **Raycast** accessibility permissions on first launch.
- Run `./scripts/macos-defaults.sh` to apply Dock / Finder / keyboard tweaks.
- Log out and back in after running macOS defaults — menu-bar hide and key-repeat settings need a fresh session.
