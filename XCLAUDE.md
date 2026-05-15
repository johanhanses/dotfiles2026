# XClaude handbook

A terminal workflow for running multiple Claude Code sessions in parallel — one per feature branch, each in its own git worktree. Built on [`xlaude`](https://github.com/Xuanwo/xlaude) (the CLI) with a conductor.build-flavored alias layer in `zshrc/mac/.zshrc`.

## Why

Working on N things at once without:

- Stashing/unstashing across feature branches
- Tripping over a single Claude session's accumulated context
- Losing the running dev server when you switch branches

Each task gets a dedicated working tree at `../<repo>-<name>` with its own branch, its own Claude session, and its own (separate) running processes. Switch between them via `tmux`, the `xlaude dashboard`, or shell `cd`.

## Prerequisites

Already in place if you ran `mac-install.sh` on this machine:

- `claude` CLI — `cl` alias in `.zshrc`
- `xlaude` — `cargo install xlaude` (not in Brewfile; the binary lives in `~/.cargo/bin/xlaude`)
- `gh` — for PR creation in `tship`, optional but recommended
- `jq` — used in some xlaude internals
- `fzf` — for the `wtc`-style picker if you build one (not currently aliased)
- `tmux` — for `treview` and `tdash`

Shell completions for `xlaude` are loaded from `~/.zfunc/_xlaude` (generated once with `xlaude completions zsh > ~/.zfunc/_xlaude`); `.zshrc` already adds `~/.zfunc` to `fpath` and runs `compinit`.

## Command reference

### Conductor-style verbs (the recommended surface)

| Alias / fn | Conductor concept | What it does |
|---|---|---|
| `task <name> [base]` | "create workspace" | `xlaude create <name>` off `[base]` (default HEAD), then `xlaude open <name>` to launch Claude inside it |
| `tasks` | sidebar list | `xlaude list` — shows all in-flight workspaces with paths and last prompt |
| `tcd <name>` | jump-to-workspace | `cd` into the worktree without launching Claude |
| `treview [base]` | right-pane diff | inside tmux, splits the current window into `diff <base>...HEAD` + a shell pane (default base: `main`) |
| `tship` | "ship it" | shows `git status -s`, prompts, then `gh pr create --fill`. Doesn't delete the worktree — that's manual via `xlaude delete` after merge. |
| `tsetup` | per-repo setup script | runs `conductor.json` (`scripts.setup`, conductor.build format) if present, otherwise an executable `.conductor/setup` or `.xlaude/setup`. Sets `$CONDUCTOR_ROOT_PATH` to the main worktree path. |
| `tdash` | dashboard | `xlaude dashboard` — interactive TUI for managing sessions across all worktrees (see keys below) |

### Raw xlaude shortcuts (lower-level)

| Alias / fn | Maps to |
|---|---|
| `xl` | `xlaude list` |
| `xc` | `xlaude create` |
| `xo` | `xlaude open` |
| `xd` | `xlaude delete` |
| `xcd <name>` | `cd "$(xlaude dir <name>)"` |
| `xv <name>` | `nvim "$(xlaude dir <name>)"` |

### Full xlaude commands (no alias — type the full thing)

| Command | When to reach for it |
|---|---|
| `xlaude checkout <branch\|pr-number>` | start a worktree from an existing branch or a GitHub PR (`xlaude checkout 123`) |
| `xlaude add` | register an existing worktree (not created by xlaude) so it appears in `xlaude list` |
| `xlaude rename <old> <new>` | rename a tracked worktree |
| `xlaude clean` | reconcile state when worktrees were deleted outside xlaude (e.g. `rm -rf`) |
| `xlaude config` | open the JSON state file in `$EDITOR` |
| `xlaude dir <name>` | print the worktree path (used by `xcd`/`xv`/`tcd`) |
| `xlaude list --json` | machine-readable workspaces (handy for scripting) |
| `xlaude completions <shell>` | regenerate completions |

State lives at `~/Library/Application Support/com.xuanwo.xlaude/state.json`.

## Typical workflow

```sh
# in the repo you want to work on
cd ~/Repos/github.com/Digital-Tvilling/dt-apps

# kick off a new task; opens claude in the new worktree
task auth-rewrite

# (later, in another shell or tmux window) see what's running
tasks
# 📦 dt-apps
#   • auth-rewrite     Path: ../dt-apps-auth-rewrite     "fix login redirect"
#   • billing-fix      Path: ../dt-apps-billing-fix      "extract Stripe webhook handler"

# jump into one without launching a new claude
tcd auth-rewrite

# review what's changed against main (inside tmux)
treview              # split: git diff main...HEAD | shell

# ready to ship
tship                # git status, prompt, gh pr create --fill

# after merge, prune
xd auth-rewrite
```

### Multi-tasking variant (the conductor sweet spot)

Open 3–5 tasks in flight, switch between them with `tdash`:

```sh
task fix-stripe-webhook
task add-pagination
task investigate-flaky-test
tdash                # interactive TUI; pick which one to focus
```

### `tdash` keybindings (the interactive TUI)

Two-pane layout: project list on the left, session details on the right. The status footer always shows the current bindings; this table is just for reference.

> **Nested-tmux gotcha**: xlaude v0.7's `Enter` action calls `tmux attach-session`, which tmux refuses inside an existing session — you see a flash (the "sessions should be nested with care" warning) and nothing happens. The `tdash` shell function in `.zshrc` works around this by invoking xlaude with `$TMUX` unset (`env -u TMUX xlaude dashboard`) so the inner `tmux attach` can take over the current terminal. When you detach (`Ctrl+Q`), you return to your outer tmux session. If you call `xlaude dashboard` directly instead of `tdash`, you'll hit the original bug.

| Key       | Action                                                       |
|-----------|--------------------------------------------------------------|
| `↑` / `↓` | Navigate projects / sessions                                 |
| `Enter`   | Open the focused worktree (launches Claude in it)            |
| `n`       | New worktree — prompts for a name, creates it, opens Claude  |
| `d`       | Stop the running session in this worktree                    |
| `c`       | Open xlaude config (`state.json`) in `$EDITOR`               |
| `r`       | Refresh the view                                             |
| `?`       | Help overlay                                                 |
| `q`       | Quit the dashboard                                           |

So **yes, you can create a new worktree from inside `tdash`** — press `n`. Same effect as running `task <name>` from a shell, but you stay inside the dashboard for follow-up actions.

## Testing — sanity checks

Run these in a throwaway repo to confirm everything is wired:

```sh
# 1. setup throwaway repo
cd /tmp && rm -rf xlaude-test && mkdir xlaude-test && cd xlaude-test
git init -q && git checkout -q -b main
git commit --allow-empty -q -m initial
xlaude add                   # register the repo with xlaude

# 2. create a workspace
xlaude create feat-a         # check: ../xlaude-test-feat-a created
xlaude list                  # check: feat-a appears, path is correct

# 3. verify conductor aliases
type task tasks tcd treview tship tsetup tdash | head
# expect: each prints "is a shell function" or "is an alias"

# 4. dir lookup
xlaude dir feat-a            # prints absolute path

# 5. cleanup
echo y | xlaude delete feat-a
echo y | xlaude delete main
xlaude clean                 # in case any state lingered
cd / && rm -rf /tmp/xlaude-test
```

If `xlaude list` shows phantom worktrees (paths that don't exist), run `xlaude clean` — it removes invalid entries from the state file. This happens when you delete worktree dirs via `rm -rf` or branches via `git branch -D` without going through `xlaude delete`.

## Conventions

- **Worktree path format:** `../<repo-name>-<task-name>`. xlaude enforces this — don't override it.
- **Branch names match task names.** `task foo` creates branch `foo` (off the current HEAD by default).
- **Per-repo setup scripts.** Three formats supported (first match wins):
  1. `conductor.json` at the repo root with `{"scripts": {"setup": "<cmd>"}}` — conductor.build format. The command runs with `$CONDUCTOR_ROOT_PATH` set to the main worktree path (useful for `ln -sf "$CONDUCTOR_ROOT_PATH/apps/foo/.env" apps/foo/.env`).
  2. Executable `.conductor/setup`.
  3. Executable `.xlaude/setup`.

  Use these for `npm install` / DB seeding / `.env` symlinking after a fresh worktree.
- **Don't `rm -rf` worktrees.** Use `xlaude delete <name>` so the state file and the branch get cleaned together. If you already did, `xlaude clean` recovers.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `tasks` shows no output but you have worktrees | `xlaude add` while inside each existing worktree to register them, OR `xlaude clean` to drop stale entries |
| `task <name>` fails with "branch already exists" | use `xlaude checkout <name>` instead (it re-attaches a worktree to an existing branch) |
| `treview` says "needs to run inside tmux" | start tmux first, or use `xlaude dashboard` for a non-tmux multi-task view |
| `tship` opens a PR but you didn't want to | the prompt was `[y/N]` — anything other than `y` or `yes` aborts; the function exits non-zero so no PR is opened |
| `xlaude list` shows entries with `Error: not a terminal` after a script | benign — xlaude tried to prompt "open in claude now?" but stdin wasn't a TTY. The worktree was still created. |
| Completions don't autocomplete `xlaude <TAB>` | regenerate: `xlaude completions zsh > ~/.zfunc/_xlaude` and `compinit` (or new shell) |

## When NOT to use this

- **One-line edits / quick scripts.** Don't bother with a worktree for `fix typo`. Just edit `main`.
- **Refactors that span many areas of one codebase concurrently.** A single Claude session with good context is often better than splitting work across worktrees that need to merge later.
- **Repos with monolithic build state** (e.g. heavy CMake configs or per-checkout machine setup). The per-worktree setup cost negates the parallelism benefit. Make `tsetup` cheap or skip the pattern.

## Files this touches in the repo

- `zshrc/mac/.zshrc` — alias block (search for "conductor-style task workflow")
- `~/.zfunc/_xlaude` — completions (not in repo; regenerate as needed)
- `~/Library/Application Support/com.xuanwo.xlaude/state.json` — xlaude state (not in repo)

Upstream: https://github.com/Xuanwo/xlaude — note: no LICENSE file in the repo as of writing.
