# Omarchy macOS Plan vs Current Setup — Comparison

## Context
Comparing the Omarchy-inspired macOS setup plan against what's currently configured on this machine. The goal is to identify what's already in place, what differs, and what's missing.

---

## 1. Installed Software

### CLI Tools — Already Installed (14/19)
`git`, `neovim`, `ghostty`, `starship`, `btop`, `ripgrep`, `bat`, `eza`, `fzf`, `gh`, `lazygit`, `delta`, `jq`, `tmux`

### CLI Tools — Missing
| Tool | Purpose |
|------|---------|
| `yazi` | TUI file manager (config exists but binary not installed via brew) |
| `fd` | find replacement |
| `zoxide` | smarter cd |
| `mise` | runtime version manager |
| `yq` | YAML processor |
| `sketchybar` | status bar |

### Cask Apps — Already Installed
`1password`, `ghostty`, `obsidian`

### Cask Apps — Missing
`aerospace`, `raycast`, `arc`, `spotify`, `orbstack`, `zoom`, `hiddenbar`, `tailscale`

### Taps — Missing
`FelixKratz/formulae` (SketchyBar), `nikitabobko/tap` (Aerospace)

### Fonts
- **Current**: `font-meslo-lg-nerd-font`, `font-sf-mono-nerd-font-ligaturized`
- **Plan**: `font-jetbrains-mono-nerd-font`
- Note: You already have Nerd Fonts, just a different family

### Extra tools you have (not in the plan)
`awscli`, `buku`, `fastfetch`, `ffmpeg`, `kubectx`, `node@22`, `ollama`, `pnpm`, `python@3.13`, `python@3.14`, `saml2aws`, `screenresolution`, `stylua`, `tree-sitter`, `zellij`, `zsh-autosuggestions`, `zsh-syntax-highlighting`

---

## 2. Theme

| Component | Plan | Current |
|-----------|------|---------|
| Overall | Tokyo Night everywhere | **Catppuccin Macchiato** everywhere |
| Ghostty | `tokyonight` | `catppuccin-macchiato` (dark) / `catppuccin-latte` (light) |
| Neovim | `tokyonight-night` | **Catppuccin** with dynamic dark/light switching based on OS |
| btop | `tokyonight` | `catppuccin_macchiato` |
| bat | (not specified) | `Catppuccin Macchiato` |
| Starship | Tokyo Night preset | Custom config (not Tokyo Night preset) |

**Verdict**: You have a cohesive theme — it's just Catppuccin instead of Tokyo Night. Both are dark, well-supported themes. Your setup adds dynamic light/dark switching which the plan doesn't have.

---

## 3. Window Management (Aerospace)

| Aspect | Plan | Current |
|--------|------|---------|
| Tiling WM | Aerospace with full hjkl bindings | **Not installed** |
| Gaps | 8px inner/outer | N/A |
| Workspace switching | Cmd+1–5 | N/A |

**This is the biggest gap.** No tiling window manager is configured.

---

## 4. Status Bar (SketchyBar)

| Aspect | Plan | Current |
|--------|------|---------|
| Bar | SketchyBar with workspace indicators, clock, battery | **Not installed** |
| Native menu bar | Hidden | Visible (default) |

**Second biggest gap.** No custom status bar.

---

## 5. App Launcher

| Aspect | Plan | Current |
|--------|------|---------|
| Launcher | Raycast (Cmd+Space) | **macOS Spotlight** (default) |

---

## 6. Terminal (Ghostty)

| Setting | Plan | Current |
|---------|------|---------|
| Font | JetBrainsMono Nerd Font, 14 | **CommitMono Bold, 13** |
| Theme | tokyonight | catppuccin-macchiato / catppuccin-latte |
| Padding | 12x12 | **5x0** (minimal) |
| Title bar | hidden | **Not set** (default macOS title bar) |
| Splits | cmd+d / cmd+shift+d | **Not configured** |
| Background | solid | **90% opacity + 20px blur** |
| Scrollback | default | **10M lines** |
| Confirm close | false | **Not set** |

---

## 7. Shell (zsh)

| Feature | Plan | Current |
|---------|------|---------|
| Prompt | Starship (Tokyo Night preset) | Starship (custom config) |
| zoxide | Yes (`alias cd="z"`) | **Not installed** |
| mise | Yes | **Not installed** |
| eza aliases | `ls`, `ll`, `tree` | Similar (`ls`, `ll`, `la`, `lt`) |
| bat alias | `cat="bat --style=plain"` | `cat="bat"` |
| Git aliases | `gs`, `gc`, `gca`, `gp`, `gl=lazygit`, `gd` | `gs`, `gc`, `gm`, `gd`, `gp`, `ga`, `gcb`, `gcm`, `wip` |
| fzf | Configured with fd | Configured (but fd not installed) |
| History | 10000 lines | **25000 lines** |
| zsh plugins | None specified | **zsh-autosuggestions + zsh-syntax-highlighting** |
| yazi `y()` function | Yes | **Not present** (yazi not installed via brew) |

**Your shell is more feature-rich** in some ways (autosuggestions, syntax highlighting, larger history, more aliases).

---

## 8. Editor (Neovim / LazyVim)

| Feature | Plan | Current |
|---------|------|---------|
| Framework | LazyVim | LazyVim ✓ |
| Theme | tokyonight-night | Catppuccin (dynamic dark/light) |
| Extra plugins | None specified | Neo-tree, No-Neckpain, ClaudeCode, Snacks |

**Already well-configured.** Your setup is arguably more sophisticated with dynamic theme switching and additional plugins.

---

## 9. File Manager (yazi)

| Feature | Plan | Current |
|---------|------|---------|
| Config | Full yazi.toml + keymap.toml | yazi.toml exists (show_hidden=true, nvim opener) |
| Keymap | Custom (gh=home, gc=config) | **Missing** |
| Image preview | iterm2 protocol | **Not configured** |

---

## 10. btop

| Setting | Plan | Current |
|---------|------|---------|
| Theme | tokyonight | catppuccin_macchiato |
| vim_keys | True | **Not set** |
| Update rate | 1000ms | 2000ms |
| Graph symbols | braille | braille ✓ |
| Rounded corners | True | **Not set** |

---

## 11. macOS System Settings

| Setting | Plan | Current | Match? |
|---------|------|---------|--------|
| Dock auto-hide | true | true | ✓ |
| Dock delay | 0 | default | ✗ |
| Dock animation | 0 | default | ✗ |
| Dock show-recents | false | false | ✓ |
| Dock tile size | 48 | 35 | ~ (yours is smaller) |
| Finder path bar | true | true | ✓ |
| Finder status bar | true | true | ✓ |
| Key repeat rate | 1 (fastest) | default | ✗ |
| Initial key repeat | 10 (fastest) | default | ✗ |
| Autocorrect disabled | true | default | ✗ |
| Screenshots folder | ~/Pictures/Screenshots | default | ✗ (folder exists but default not set) |
| Screenshot type | png | default | ✗ |
| Tap to click | true | not checked | ? |
| Show all extensions | true | default | ✗ |

---

## Summary

### What you already have ✓
- Solid CLI toolchain (most tools installed)
- Cohesive Catppuccin theme (vs plan's Tokyo Night)
- LazyVim with good plugin setup + dynamic theming
- Ghostty terminal configured
- Starship prompt
- Sensible shell aliases and history
- Dock auto-hide + Finder improvements

### Major gaps (the "Omarchy layer")
1. **No tiling window manager** — Aerospace not installed
2. **No custom status bar** — SketchyBar not installed
3. **No Raycast** — still on Spotlight
4. **macOS keyboard tweaks** — key repeat, autocorrect, dock animation not tuned

### Minor gaps
- Missing `fd`, `zoxide`, `mise`, `yq`
- Ghostty title bar not hidden, no split keybinds
- Screenshot location not set in defaults
- btop missing vim_keys
- No yazi keymap customizations

### Where your setup is arguably better
- **Dynamic light/dark theme switching** (OS-aware)
- **zsh-autosuggestions + syntax-highlighting** (not in plan)
- **Larger history** (25k vs 10k)
- **Zellij** available as tmux alternative
- **More Neovim plugins** (ClaudeCode, No-Neckpain, Snacks)
- **Semi-transparent terminal** with blur effect

---

## Original Plan Reference

The full Omarchy macOS plan this was compared against includes:

- **Aerospace** for tiling window management (hjkl focus/move/resize, Cmd+1–5 workspaces)
- **Raycast** replacing Spotlight as launcher
- **SketchyBar** as scriptable status bar with Tokyo Night palette
- **Ghostty** with Tokyo Night, JetBrainsMono Nerd Font, hidden title bar, split keybinds
- **zsh + Starship** with Tokyo Night preset, zoxide, mise, fzf
- **LazyVim** with tokyonight-night colorscheme
- **yazi** for file management with iterm2 image preview
- **Mise** for runtime version management
- **btop** with Tokyo Night theme, vim keys, rounded corners
- **macOS defaults** for instant dock, fastest key repeat, no autocorrect, screenshots to ~/Pictures/Screenshots
- **Apps**: Arc, 1Password, Spotify, Obsidian, OrbStack, Zoom, HiddenBar, Tailscale
