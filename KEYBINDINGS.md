# Keybindings Reference

Every shortcut configured in this dotfiles setup. Source of truth for each tool is its config file under the repo; this is the cross-reference.

| Symbol | Key        |
|--------|------------|
| `⌘`    | Cmd        |
| `⌃`    | Ctrl       |
| `⇧`    | Shift      |
| `␣`    | Space      |

For tmux, `<prefix>` = `⌃a` unless rebound.

---

## Window manager — Moom 3

GUI-configured via the Moom menubar app. Bindings are not versioned in this repo (live in `~/Library/Preferences/com.manytricks.Moom.plist`).

Native macOS Mission Control / Spaces are kept on — Moom is layout-only, not a tiling WM.

---

## Launcher — Spotlight

Native macOS Spotlight. After `mac-install.sh`, rebind `⌘␣` to Spotlight in **System Settings → Keyboard → Keyboard Shortcuts → Spotlight**.

| Keys  | Action          |
|-------|-----------------|
| `⌘␣`  | Open Spotlight  |

Light/Dark toggle runs via a custom **Shortcut** (Apple Shortcuts app) wired into Spotlight — it flips `AppleInterfaceStyle` then runs `scripts/theme-sync`. The Shortcut lives outside this repo.

---

## Terminal — Ghostty

BlexMono Nerd Font 14, Atom One Light/Dark (auto-switches with macOS).

| Keys             | Action               |
|------------------|----------------------|
| `⌘D`             | Split right          |
| `⌘⇧D`            | Split down           |
| `⌘⇧H`            | Focus previous split |
| `⌘⇧L`            | Focus next split     |
| `⌘⇧↩`            | Toggle split zoom    |
| `⌘W`             | Close surface        |
| `⌘T`             | New tab (default)    |
| `⌘N`             | New window (default) |
| `⌘⇧,`            | Reload config        |
| `⌘+` / `⌘-`      | Font size up/down    |

**Config**: `ghostty/config`

---

## Multiplexer — tmux

Prefix `⌃a`. tpm plugins: `tmux-sensible`, `tmux-yank`. Atom One Dark/Light theme picked at startup, re-sourced on reload.

| Keys                  | Action                                                          |
|-----------------------|-----------------------------------------------------------------|
| `⌃a`                  | Prefix                                                          |
| `<prefix>+r`          | Reload config + sync theme (tmux + Mattermost)                  |
| `<prefix>+t`          | Sesh popup — fuzzy session picker (cross-repo jump)             |
| `<prefix>+s`          | Built-in `choose-tree` session picker                           |
| `<prefix>+\|`         | Split horizontally                                              |
| `<prefix>+-`          | Split vertically                                                |
| `<prefix>+c`          | New window in current dir                                       |
| `<prefix>+n` / `p`    | Next / previous window (repeatable)                             |
| `<prefix>+⌃n` / `⌃p`  | Alternate next / previous window                                |
| `<prefix>+<` / `>`    | Swap current window left / right (repeatable)                   |
| `<prefix>+.`          | Move current window to a specific index                         |
| `<prefix>+h/j/k/l`    | Select pane (repeatable)                                        |
| `<prefix>+⌃h` / `⌃l`  | Previous / next window                                          |
| `<prefix>+b`          | Toggle status bar                                               |
| `<prefix>+P`          | Paste from macOS clipboard                                      |
| `⌃h/j/k/l`            | Seamless pane / split navigation (tmux ↔ nvim, vim-tmux aware)  |

### Copy mode (vi)

| Keys           | Action                  |
|----------------|-------------------------|
| `<prefix>+[`   | Enter copy mode         |
| `v`            | Begin selection         |
| `y` / `↩`      | Copy to macOS clipboard |
| `q`            | Exit copy mode          |

**Config**: `tmux/tmux.conf`
**Themes**: `tmux/themes/atom-one-{dark,light}.tmux`
**Layout script**: `scripts/ide` for a multi-pane dev layout

---

## Editor — Neovim

Leader: `␣`. Custom `lazy.nvim` setup (not LazyVim). Atom One via `onedarkpro.nvim` + `auto-dark-mode.nvim`.

### Core (config/keymaps.lua)

| Keys                  | Action                                              |
|-----------------------|-----------------------------------------------------|
| `␣`                   | Leader (which-key menu after a beat)                |
| `<Esc>`               | Clear search highlight                              |
| `j` / `k` (n/x)       | Down/up with visual-line wrap awareness (`gj`/`gk`) |
| `J` / `K` (v)         | Move selected lines down/up                         |
| `<` / `>` (v)         | Indent left/right and re-select                     |
| `ö` (n/v)             | Jump to end of line (`$` — Swedish keyboard hack)   |
| `<C-↑/↓/←/→>`         | Resize splits                                       |
| `[b` / `]b`           | Previous / next buffer                              |
| `<leader>bd`          | Delete buffer                                       |
| `<leader>w` / `q`     | Save / quit                                         |
| `<leader>l`           | Open Lazy plugin manager                            |

### Find (Snacks picker — includes `.env` and gitignored files)

| Keys           | Action       |
|----------------|--------------|
| `<leader><space>` | Find files |
| `<leader>ff`   | Find files   |
| `<leader>fg`   | Grep         |
| `<leader>/`    | Grep         |
| `<leader>fb`   | Buffers      |
| `<leader>fr`   | Recent files |
| `<leader>fh`   | Help         |

### LSP (loaded per-buffer when an LSP attaches)

| Keys           | Action      |
|----------------|-------------|
| `<leader>ca`   | Code action |
| `<leader>cr`   | Rename      |

### Formatting

| Keys           | Action            |
|----------------|-------------------|
| `<leader>cf`   | Format (`conform`) |

### Claude Code (`coder/claudecode.nvim`)

| Keys              | Action                       |
|-------------------|------------------------------|
| `<leader>ac`      | Toggle Claude                |
| `<leader>af`      | Focus Claude                 |
| `<leader>ar`      | Resume Claude (`--resume`)   |
| `<leader>aC`      | Continue Claude (`--continue`)|
| `<leader>am`      | Select Claude model          |
| `<leader>ab`      | Add current buffer to Claude |
| `<leader>as` (v)  | Send selection to Claude     |
| `<leader>aa`      | Accept diff                  |
| `<leader>ad`      | Deny diff                    |

### UI

| Keys           | Action                |
|----------------|-----------------------|
| `<leader>nn`   | Toggle No-Neck-Pain   |

**Plugin configs**: `nvim/lua/plugins/*.lua`

---

## Shell — zsh

### fzf (default key bindings)

| Keys     | Action                  |
|----------|-------------------------|
| `⌃R`     | Fuzzy history           |
| `⌃T`     | Fuzzy file (uses `fd`)  |
| `⎇c`     | Fuzzy cd into directory |

### zsh-autosuggestions

| Keys     | Action               |
|----------|----------------------|
| `→`      | Accept suggestion    |
| `⌃→`     | Accept one word      |

### Navigation aliases

| Alias    | Expands to |
|----------|------------|
| `repos`  | `cd $REPOS` |
| `ghrepos`| `cd $GHREPOS` |
| `dot`    | `cd $DOTFILES` |
| `scripts`| `cd $DOTFILES/scripts` |
| `dt`     | `cd $REPOS/github.com/Digital-Tvilling` |
| `plan`   | `cd …/DT-Frontend-planning` |
| `rtm`    | `cd …/dt-apps` |
| `deploy` | `cd …/deployment-configuration` |
| `backend`| `cd …/deployment-configuration/external/localhost` |
| `dti`    | `cd …/dti` |
| `dev`    | `cd …/digital-tvilling-dev` |
| `prod`   | `cd …/digital-tvilling-prod` |
| `home`   | `cd …/johanhanses.com` |
| `sb`     | `cd $SECOND_BRAIN` |
| `config` | `cd $XDG_CONFIG_HOME` |

### Tool aliases

| Alias     | Expands to                       |
|-----------|----------------------------------|
| `cat`     | `bat --style=plain`              |
| `ll`      | `eza -laag --group-directories-first --show-symlinks --icons=always` |
| `l`       | `eza -lg --group-directories-first --show-symlinks --icons=always` |
| `la`      | `ls -lathr`                      |
| `tree`    | `eza --tree`                     |
| `lg`      | `lazygit`                        |
| `nv`      | `nvim`                           |
| `cl`      | `claude`                         |
| `ca`      | `cursor-agent`                   |
| `c`       | `clear`                          |
| `e`       | `exit`                           |
| `szr`     | `source ~/.zshrc`                |

### Git aliases

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

### Worktree aliases

See [WORKTREES.md](WORKTREES.md) for the full handbook.

| Alias / fn         | Action                                                                      |
|--------------------|-----------------------------------------------------------------------------|
| `wt <name> [base]` | New feature worktree from `[base]` (default `main`). Auto-runs `tsetup`, launches Claude as a window in the per-repo tmux session. |
| `wtp <pr>`         | New worktree from a remote PR (number or URL). Same session routing as `wt`. |
| `wtl`              | `git worktree list`                                                         |
| `wtc`              | fzf-pick a worktree of the current repo; switches to (or creates) its window in the per-repo session |
| `wts`              | sesh popup — cross-repo session picker from any shell                       |
| `wta <name>`       | Archive: remove worktree dir, keep branch (`-f`/`--force` to drop modified/untracked) |
| `wtd <name>`       | Delete: remove worktree dir AND branch (`-f`/`--force` also force-deletes unmerged branch) |
| `treview`          | tmux split with `git diff main...HEAD` + shell                              |
| `tship`            | `git status -s` + prompt + `gh pr create --fill`                            |
| `tsetup`           | bootstrap: conductor.json → `.conductor/.wt/setup` hook → smart fallback (symlink `.env*` from main + `pnpm/yarn/npm install`) |

### Misc aliases

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
| `n`   | `npm`                   |
| `nr`  | `npm run`               |
| `ns`  | `npm start`             |

**Config**: `zshrc/mac/.zshrc`

---

## System monitor — btop

`tokyo-night` theme (intentionally separate from the Atom One palette).

| Keys      | Action            |
|-----------|-------------------|
| `h/j/k/l` | Navigate          |
| `Esc`     | Open menu         |
| `q`       | Quit              |
| `f`       | Filter processes  |
| `⇧K`      | Kill process      |
| `+` / `-` | Speed up / slow down |
| `r`       | Reverse sort      |

**Config**: `btop/btop.conf`

---

## RSS — newsboat

| Keys    | Action               |
|---------|----------------------|
| `j/k`   | Down / up            |
| `J/K`   | Next / previous feed |
| `g/G`   | Top / bottom         |
| `l`     | Open link            |
| `h`     | Quit / back          |
| `r`     | Reload feed          |
| `R`     | Reload all           |
| `A`     | Mark feed read       |

**Config**: `newsboat/config`

---

## Mattermost TUI — matterhorn

Standard matterhorn bindings (see `matterhorn -K` for the live cheatsheet). Theme overlays live under `matterhorn/`; not auto-switched with macOS.

**Config**: `matterhorn/config.ini`

---

## Post-install reminders

- Rebind `⌘␣` to **Spotlight** in System Settings.
- Run `./scripts/macos-defaults.sh` for Dock / Finder / keyboard tweaks; log out + back in afterwards.
- Inside tmux, hit `<prefix>+I` once to fetch tpm plugins.
- Wire `scripts/theme-sync` into your macOS Shortcut so Mattermost / tmux follow Light/Dark toggles.
