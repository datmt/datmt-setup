# datmt-setup

Personal dev environment backup + shareable "AI-heavy dev" starter kit.

Covers:
- **tmux** — `.tmux.conf`, catppuccin theme, TPM plugin manager (vendored)
- **nvim** — Lua config, lazy.nvim plugin lockfile
- **rich-history** — shell history search tool (own repo, own installer)
- **claude-code/** — [Claude Code](https://claude.com/claude-code) config: global `CLAUDE.md`, `settings.json`, and custom skills

## Install

```sh
git clone https://github.com/datmt/datmt-setup.git ~/datmt-setup
cd ~/datmt-setup
./install.sh
```

`install.sh` symlinks each piece into place (`~/.tmux.conf`, `~/.config/nvim`, `~/.claude/CLAUDE.md`, `~/.claude/skills/*`, ...). It's safe to re-run: existing real files get moved once to `~/.datmt-setup-backup/<timestamp>/` before the symlink is made; a file that's already a symlink from this repo is just re-linked.

After the first install:
- tmux: press `prefix + I` to fetch any missing TPM plugins.
- Claude Code: `~/.claude/settings.json` enables two plugins (`caveman`, `mattpocock-skills`) from the marketplaces declared in that file. If `~/.claude/settings.json` already existed on your machine, the installer leaves it untouched and prints a note — merge by hand.

## What's in `claude-code/`

- `CLAUDE.md` — global instructions loaded into every session.
- `settings.json` — model, hooks, statusline, enabled plugins/marketplaces. Machine-specific `settings.local.json` (permissions) is intentionally **not** backed up here — that's local by design.
- `skills/` — custom and third-party skills installed directly under `~/.claude/skills/` (not plugin-managed), e.g. `graphify` (turn any input into a knowledge graph) and the Cloudflare Workers skill pack.

## Layout

```
.tmux.conf          tmux config
.tmux/plugins/       vendored TPM + catppuccin
nvim/                neovim config (~/.config/nvim)
rich-history/         shell history tool, self-installing
claude-code/          Claude Code global config
install.sh            symlinks everything above into $HOME
```
