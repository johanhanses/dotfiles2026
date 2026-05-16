# Worktrees handbook

Running multiple Claude Code sessions in parallel — one per feature branch — using Claude Code's **built-in** `--worktree` flag plus a thin layer of zsh + tmux. No external tooling, no state file, no nested-tmux workarounds.

(Supersedes the prior xlaude-based setup. `XCLAUDE.md` was deleted; this is its replacement.)

## Why this over xlaude

`claude --worktree <name>` is shipped with Claude Code itself and handles:

- Creating the git worktree (at `<repo>/.claude/worktrees/<name>`)
- Creating the branch (`worktree-<name>`)
- cd'ing into it and starting Claude

No separate state file to drift, no `xlaude clean`, no global tmux binding pollution, no "tdash Enter dies in nested tmux" gotcha. The `git worktree list` output is the single source of truth.

## Prerequisites

Already on this machine:

- `claude` (Claude Code CLI 2.x) — `cl` alias in `.zshrc`
- `git` ≥ 2.36
- `gh` — used by `tship` for PR creation
- `jq` — used by `tsetup` for `conductor.json` parsing
- `fzf` — used by `wtc`
- `tmux`

## Command reference

| Alias / fn      | Action                                                                                  |
|-----------------|-----------------------------------------------------------------------------------------|
| `wt <name>`     | `claude --worktree <name> --permission-mode auto`. Inside tmux → new window in current session. |
| `wtl`           | `git worktree list`                                                                     |
| `wtd <name>`    | `git worktree remove <repo>/.claude/worktrees/<name>` + `git branch -d worktree-<name>` |
| `wtc`           | `fzf`-pick from `git worktree list`; open in new tmux window or `cd`                    |
| `treview [base]`| Inside tmux, split current window into `git diff <base>...HEAD` + shell (default `main`)|
| `tship`         | `git status -s`, prompt, then `gh pr create --fill`                                     |
| `tsetup`        | Run `conductor.json` (`scripts.setup`) or `.conductor/setup` / `.xlaude/setup` hook. Sets `$CONDUCTOR_ROOT_PATH` to the main worktree. |

## Conventions (decided by Claude Code, not us)

- **Worktree path**: `<repo>/.claude/worktrees/<name>` — siblings of one another, inside the repo root. Not at `../<repo>-<name>` like xlaude/conductor did.
- **Branch name**: `worktree-<name>` — prefixed. So `wt foo` creates branch `worktree-foo`.
- **`.claude/` in the repo**: most repos that use Claude Code already have `.claude/` either gitignored or treated as untracked. Worktrees live inside it; `git worktree remove` cleans them up. Add `.claude/worktrees/` to `.gitignore` if your repo is strict about untracked files.

## Typical workflow

```sh
cd ~/Repos/github.com/Digital-Tvilling/dt-apps
wt auth-rewrite               # new tmux window, claude launches in worktree
# … work in that window …
treview                       # tmux split with diff against main + shell
tship                         # gh pr create --fill (after committing)
# after merge:
wtd auth-rewrite              # cleans worktree + deletes branch
```

### Switching between in-flight worktrees

```sh
wtl                           # see what's open
wtc                           # fzf-pick, jumps you into a new tmux window
```

### Per-repo setup (e.g. dt-apps)

If the repo has a `conductor.json` (conductor.build format) at the root:

```json
{
  "scripts": {
    "setup": "npm install && ln -sf \"$CONDUCTOR_ROOT_PATH/apps/foo/.env\" apps/foo/.env"
  }
}
```

then in a freshly-created worktree, run `tsetup` — it picks up the script, exports `$CONDUCTOR_ROOT_PATH` (the main worktree path via `git worktree list`), and executes it. Alternatives: executable `.conductor/setup` or `.xlaude/setup` at the repo root.

## Testing

Drop into a throwaway repo to confirm the wiring:

```sh
cd /tmp && rm -rf wt-test && mkdir wt-test && cd wt-test
git init -q && git checkout -q -b main
git commit --allow-empty -q -m init

type wt wtl wtd wtc                # all defined
wt scratch &                       # creates .claude/worktrees/scratch (& only for test)
sleep 1; jobs %1 >/dev/null && kill %1
git worktree list                  # shows .claude/worktrees/scratch on branch worktree-scratch
wtd scratch                        # removes worktree + branch
git worktree list                  # back to just main
cd / && rm -rf /tmp/wt-test
```

In normal use you'd never use `&` — just `wt scratch` and a new tmux window opens with Claude inside.

## Troubleshooting

| Symptom                                    | Fix                                                                                       |
|--------------------------------------------|-------------------------------------------------------------------------------------------|
| `wt` says "branch already exists"          | Either delete the old branch (`git branch -D worktree-<name>`) or pick a different name. |
| `wtd` says worktree has uncommitted changes | Commit, stash, or `git worktree remove --force` manually. The function intentionally fails loud. |
| `git worktree list` shows a stale entry    | `git worktree prune` — git's built-in cleanup, no separate state to reconcile.            |
| Claude Code launched in the wrong dir      | Run `wt` from the repo root, not a subdir.                                                |

## When NOT to use this

- **One-line edits / quick scripts.** Just edit on `main`.
- **Refactors that span the whole repo concurrently.** A single Claude session with good context usually beats N split sessions that have to merge later.
- **Repos with monolithic build state** (heavy CMake, per-checkout machine setup). Per-worktree setup cost negates the parallelism. Make `tsetup` cheap or skip the pattern.
