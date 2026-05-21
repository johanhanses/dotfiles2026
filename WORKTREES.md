# Worktrees handbook

Two clear entry points, automatic setup, two-tier cleanup, **one tmux session per repository**. Built on plain `git worktree` + `gh` + `sesh` + a small zsh layer. No external state, no daemons.

## Why this shape

The two workflows that come up over and over:

1. **Start a new feature** → `wt <name>`
2. **Pull down an existing remote PR to play with / review / iterate** → `wtp <pr>`

Both create a worktree at `<repo>/.claude/worktrees/<name>`, run `tsetup` to wire `.env` files + install dependencies, then launch Claude inside it. The worktree opens as a **window inside the per-repo tmux session** (session name = repo basename). Cross-repo jumping is `<prefix>+t` (sesh popup) or `wts` from any shell.

When done, two cleanup levels: **archive** keeps the branch (you might come back), **delete** removes the branch too (PR merged, branch dead).

## Session-per-repo layout

```
sessions          windows (= worktrees)
────────          ─────────────────────
dt-apps           main, fix-foo, pr-1640, review-x
dotfiles2026      main, sesh-rollout, tmux-themes
zettelkasten      writing, research
```

Each session stays well under tmux's 1–9 quick-jump range. Cross-repo travel goes through the picker, not through `prefix+n/p`. **`renumber-windows on`** is enabled so closing a window never leaves gaps in 1..9.

## Prerequisites (already installed)

- `claude` (Claude Code CLI 2.x)
- `git` ≥ 2.36
- `gh` (for `wtp`)
- `jq` (for `wtp` + `tsetup` conductor.json parsing)
- `fzf` (for `wtc`, sesh picker)
- `tmux`
- `sesh` (cross-repo session picker — `brew "sesh"`, configured via `sesh/sesh.toml`)

## Command reference

| Alias / fn          | What it does                                                                        |
|---------------------|-------------------------------------------------------------------------------------|
| `wt <name> [base]`  | New worktree on branch `<name>` off `[base]` (default `main`). Runs `tsetup`. Launches Claude in a window of the per-repo session, switches focus. **Starts tmux for you if you're in a bare shell.** |
| `wtp <pr>`          | Fetches PR (number or URL) into a worktree on the PR's head branch. Runs `tsetup`. Launches Claude. Same session routing as `wt`. |
| `wtl`               | `git worktree list`                                                                 |
| `wtc`               | fzf-pick a worktree of the current repo; switches to its window in the per-repo session (creates the window if it doesn't exist) |
| `wts`               | sesh popup from any shell — fuzzy-jump to any tmux session, sesh config entry, or zoxide dir (cross-repo) |
| `wta <name>`        | **Archive** — remove the worktree dir, **keep** the branch (`-f`/`--force` to drop modified/untracked files) |
| `wtd <name>`        | **Delete** — remove the worktree dir **and** the branch (`-f`/`--force` also force-deletes unmerged branches) |
| `treview [base]`    | Inside tmux, split into `git diff <base>...HEAD` + shell (default base `main`)      |
| `tship`             | `git status -s` + prompt + `gh pr create --fill`                                    |
| `tsetup`            | Run repo bootstrap (see below). Auto-invoked by `wt` / `wtp`; safe to re-run manually. |

| Tmux keybind        | Action                                                                              |
|---------------------|-------------------------------------------------------------------------------------|
| `<prefix>+t`        | Sesh popup picker (same as `wts`)                                                  |
| `<prefix>+s`        | Built-in `choose-tree` session picker (fallback)                                    |
| `<prefix>+<` / `>`  | Swap current window left / right                                                    |

## Setup: how `tsetup` decides what to run

In order of precedence:

1. **`conductor.json`** (conductor.build format) at the repo root with `scripts.setup`. Runs it with `$CONDUCTOR_ROOT_PATH` set to the main worktree's path. Best for monorepos that need precise control (e.g. dt-apps symlinking six `.env` files).
2. **Executable hook** at `.conductor/setup`, `.xlaude/setup`, or `.wt/setup`. Whatever you want.
3. **Smart fallback** (no config needed):
   - Symlinks every `.env`, `.env.local`, `.env.development` found in the main worktree (skipping `node_modules` / `.git`) into the same relative path in the new worktree.
   - Detects the package manager via lockfile and runs install:
     - `pnpm-lock.yaml` → `pnpm install`
     - `yarn.lock` → `yarn install`
     - else → `npm install`

So a plain Node repo with a `.env` at the root needs no extra config — `wt foo` will land you in a worktree with `.env` symlinked and `node_modules` installed.

## Conventions

- **Worktree path**: `<repo>/.claude/worktrees/<name>` (siblings under `.claude/worktrees/`)
- **Branch name**: plain `<name>` — no prefix. For `wtp`, the branch name is the PR's head ref name.
- **Tmux session name**: basename of the repo's main worktree path (e.g. `dt-apps`, `dotfiles2026`). `.` and `:` get sanitized to `_` because tmux session names can't contain them.
- **Tmux window name**: `${name:t}` — the basename of the worktree name. For PR head refs like `anton/calcifer-reasoning-toggle`, the window shows as `calcifer-reasoning-toggle`.
- **`.claude/worktrees/`**: if your repo cares, add it to `.gitignore`. `git worktree` itself doesn't list these dirs in `git status`.

## Sesh config

`sesh/sesh.toml` (symlinked to `~/.config/sesh/sesh.toml`) lists static session shortcuts so common repos surface in the picker even before they've been opened. Existing tmux sessions are auto-discovered by sesh — no config needed once `wt` has spun a session up.

Add a new repo to the picker:

```toml
[[session]]
name = "<repo-basename>"
path = "<absolute-or-tilde-path>"
```

## Typical workflows

### Start a new feature

You can run `wt` from a bare Ghostty window — it'll start tmux for you and attach. Or from inside an existing tmux session — it'll route into the right per-repo session and switch focus.

```sh
cd ~/Repos/.../dt-apps
wt fix-stripe-webhook         # creates worktree, tmux session 'dt-apps' if needed,
                              # new window 'fix-stripe-webhook' with Claude.
                              # Bare shell? → attaches you to the session.
                              # Inside tmux? → switches focus to the new window.
# … code, commit, push …
tship                         # gh pr create --fill
# … PR merges …
wtd fix-stripe-webhook        # cleanup: worktree + branch gone
```

### Look at a colleague's PR

```sh
cd ~/Repos/.../dt-apps
wtp 1640                      # fetches PR #1640 head; window 'calcifer-attachments'
                              # in 'dt-apps' session; tsetup runs; Claude launches
# … review, run tests, comment on the PR …
wta calcifer-attachments      # archive the worktree dir but keep the branch around
```

### Switch between in-flight worktrees (same repo)

```sh
wtl                           # see what's open
wtc                           # fzf-pick → switches focus to that worktree's window
```

### Jump to a different repo (cross-session)

From inside tmux: `<prefix>+t` → fuzzy-pick a session.
From any shell: `wts` → same picker.

`sesh` shows existing tmux sessions, your `sesh.toml` entries, and (if installed) zoxide dirs. Selecting one attaches/switches to its session — creating a fresh one from a path if necessary.

## Cleanup choice: archive vs delete

| You want to…                                  | Use      |
|-----------------------------------------------|----------|
| Free disk, but keep the branch (resume later) | `wta`    |
| PR merged, branch can die                     | `wtd`    |

`wtd` uses `git branch -d` (refuses to delete unmerged branches) by default. `wtd -f` upgrades to `git branch -D` and also passes `--force` to `git worktree remove` (drops untracked / modified files in the worktree).

## Test the wiring

```sh
cd /tmp && rm -rf wt-test && mkdir wt-test && cd wt-test
git init -q && git checkout -q -b main
echo "FOO=bar" > .env
echo '{"name":"test","scripts":{}}' > package.json
git add . && git commit -q -m init

type wt wtp wtl wtc wta wtd wts tsetup    # all defined

tmux new-session -d -s wt-test            # need a tmux server for session routing
TMUX=$(tmux display -p '#S') wt scratch & # creates worktree, new window 'scratch'
sleep 2
tmux list-sessions                        # 'wt-test' session has a 'scratch' window
git worktree list                         # shows .claude/worktrees/scratch on branch 'scratch'
ls -la .claude/worktrees/scratch/.env     # .env should be a symlink to ../../../.env

kill %1 2>/dev/null
wta scratch                               # archive: branch kept
git branch | grep scratch                 # 'scratch' still listed
wtd scratch                               # delete: branch gone
git branch | grep scratch || echo gone

cd / && rm -rf /tmp/wt-test
tmux kill-session -t wt-test 2>/dev/null
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `wt foo` says "branch already exists" | Either pick a new name or use `wt foo foo` to attach a worktree to that existing branch. |
| `wtp <pr>` fails on a fork PR | The `refs/pull/N/head` fetch handles forks too. If it doesn't, check `gh auth status`. |
| `wtd` won't delete branch | `git branch -d` refuses unmerged branches. Follow up with `wtd -f <name>` to force-delete. |
| `tsetup` ran but `npm install` was slow | That's `npm install` doing its thing in the new worktree. To skip, drop a `.wt/setup` executable that does the lighter setup you want. |
| Stale entry in `git worktree list` | `git worktree prune` |
| `wt` created the window but didn't switch | Your tmux server may be detached / different from the one you're attached to. Confirm `$TMUX` is set in the shell where you ran `wt`. |
| Session name has a `.` or `:` | Sanitized to `_` automatically (tmux limitation). |
| Sesh picker empty | No sessions exist yet — run `wt <name>` in a repo first, or add static entries to `sesh/sesh.toml`. |

## When NOT to use this

- **One-line edits.** Just edit on `main`.
- **Refactors touching the whole repo.** A single Claude session with full context usually beats N split sessions.
- **Repos where `npm install` is enormous and `.env` is fine in-place.** The smart fallback is convenient; if it's not in your case, drop a `.wt/setup` that does the minimum or set `scripts.setup` in `conductor.json` to `:` (no-op).
