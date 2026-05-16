# Worktrees handbook

Two clear entry points, automatic setup, two-tier cleanup. Built on plain `git worktree` + `gh` + a small zsh layer. No external state, no daemons.

## Why this shape

The two workflows that come up over and over:

1. **Start a new feature** → `wt <name>`
2. **Pull down an existing remote PR to play with / review / iterate** → `wtp <pr>`

Both create a worktree at `<repo>/.claude/worktrees/<name>`, run `tsetup` to wire `.env` files + install dependencies, then launch Claude inside it. The new worktree opens in its own tmux window so the source session stays put.

When done, two cleanup levels: **archive** keeps the branch (you might come back), **delete** removes the branch too (PR merged, branch dead).

## Prerequisites (already installed)

- `claude` (Claude Code CLI 2.x)
- `git` ≥ 2.36
- `gh` (for `wtp`)
- `jq` (for `wtp` + `tsetup` conductor.json parsing)
- `fzf` (for `wtc`)
- `tmux`

## Command reference

| Alias / fn          | What it does                                                                        |
|---------------------|-------------------------------------------------------------------------------------|
| `wt <name> [base]`  | New worktree on branch `<name>` off `[base]` (default `main`). Runs `tsetup`. Launches Claude. |
| `wtp <pr>`          | Fetches PR (number or URL) into a worktree on the PR's head branch. Runs `tsetup`. Launches Claude. |
| `wtl`               | `git worktree list`                                                                 |
| `wtc`               | fzf-pick an existing worktree, open it (new tmux window / `cd`)                     |
| `wta <name>`        | **Archive** — remove the worktree dir, **keep** the branch                          |
| `wtd <name>`        | **Delete** — remove the worktree dir **and** the branch (post-merge cleanup)        |
| `treview [base]`    | Inside tmux, split into `git diff <base>...HEAD` + shell (default base `main`)      |
| `tship`             | `git status -s` + prompt + `gh pr create --fill`                                    |
| `tsetup`            | Run repo bootstrap (see below). Auto-invoked by `wt` / `wtp`; safe to re-run manually. |

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
- **`.claude/worktrees/`**: if your repo cares, add it to `.gitignore`. `git worktree` itself doesn't list these dirs in `git status`.

## Typical workflows

### Start a new feature

```sh
cd ~/Repos/.../dt-apps
wt fix-stripe-webhook         # tmux opens a new window; tsetup runs; Claude launches
# … code, commit, push …
tship                         # gh pr create --fill
# … PR merges …
wtd fix-stripe-webhook        # cleanup: worktree + branch gone
```

### Look at a colleague's PR

```sh
cd ~/Repos/.../dt-apps
wtp 1640                      # fetches PR #1640 head; tsetup runs; Claude launches in worktree
# … review, run tests, comment on the PR …
wta calcifer-attachments      # archive the worktree dir but keep the branch around
```

### Switch between in-flight worktrees

```sh
wtl                           # see what's open
wtc                           # fzf-pick, jumps to a new tmux window
```

## Cleanup choice: archive vs delete

| You want to…                                  | Use      |
|-----------------------------------------------|----------|
| Free disk, but keep the branch (resume later) | `wta`    |
| PR merged, branch can die                     | `wtd`    |

`wtd` uses `git branch -d` (refuses to delete unmerged branches). If you're sure, the hint message tells you to follow up with `git branch -D <name>`.

## Test the wiring

```sh
cd /tmp && rm -rf wt-test && mkdir wt-test && cd wt-test
git init -q && git checkout -q -b main
echo "FOO=bar" > .env
echo '{"name":"test","scripts":{}}' > package.json
git add . && git commit -q -m init

type wt wtp wtl wtc wta wtd tsetup    # all defined

wt scratch &                          # new feature worktree
sleep 2
git worktree list                     # shows .claude/worktrees/scratch on branch 'scratch'
ls -la .claude/worktrees/scratch/.env # .env should be a symlink to ../../../.env

kill %1 2>/dev/null
wta scratch                           # archive: branch kept
git branch | grep scratch             # 'scratch' still listed
wtd scratch                           # delete: branch gone
git branch | grep scratch || echo gone

cd / && rm -rf /tmp/wt-test
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `wt foo` says "branch already exists" | Either pick a new name or use `wt foo foo` to attach a worktree to that existing branch. |
| `wtp <pr>` fails on a fork PR | The `refs/pull/N/head` fetch handles forks too. If it doesn't, check `gh auth status`. |
| `wtd` won't delete branch | `git branch -d` refuses unmerged branches. Follow up with `git branch -D <name>` if you're sure. |
| `tsetup` ran but `npm install` was slow | That's `npm install` doing its thing in the new worktree. To skip, drop a `.wt/setup` executable that does the lighter setup you want. |
| Stale entry in `git worktree list` | `git worktree prune` |

## When NOT to use this

- **One-line edits.** Just edit on `main`.
- **Refactors touching the whole repo.** A single Claude session with full context usually beats N split sessions.
- **Repos where `npm install` is enormous and `.env` is fine in-place.** The smart fallback is convenient; if it's not in your case, drop a `.wt/setup` that does the minimum or set `scripts.setup` in `conductor.json` to `:` (no-op).
