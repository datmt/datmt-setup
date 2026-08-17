#!/usr/bin/env sh
# datmt-setup installer — symlinks this repo's configs into place.
# Safe to re-run. Existing real files/dirs get backed up once, not clobbered.
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.datmt-setup-backup/$(date +%Y%m%d%H%M%S)"

log() { printf '%s\n' "$*"; }

# link SRC DST — symlink SRC at DST, backing up a pre-existing real file/dir first.
link() {
  src="$1"
  dst="$2"
  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    mkdir -p "$(dirname "$BACKUP_DIR/${dst#"$HOME"/}")"
    mv "$dst" "$BACKUP_DIR/${dst#"$HOME"/}"
    log "Backed up $dst -> $BACKUP_DIR/${dst#"$HOME"/}"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  log "Linked $dst -> $src"
}

# --- tmux ---
link "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf"
link "$REPO_DIR/.tmux" "$HOME/.tmux"

# --- nvim ---
link "$REPO_DIR/nvim" "$HOME/.config/nvim"

# --- rich-history (has its own installer: clones itself + wires shell rc) ---
if [ -x "$REPO_DIR/rich-history/install.sh" ]; then
  log "Running rich-history installer..."
  sh "$REPO_DIR/rich-history/install.sh"
fi

# --- Claude Code config ---
mkdir -p "$HOME/.claude/skills"
link "$REPO_DIR/claude-code/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

if [ -e "$HOME/.claude/settings.json" ] && [ ! -L "$HOME/.claude/settings.json" ]; then
  log "NOTE: ~/.claude/settings.json already exists and was left untouched."
  log "      Compare it with $REPO_DIR/claude-code/settings.json and merge by hand"
  log "      (it references plugin cache paths that only exist after 'claude plugin install')."
else
  link "$REPO_DIR/claude-code/settings.json" "$HOME/.claude/settings.json"
fi

for skill_dir in "$REPO_DIR"/claude-code/skills/*/; do
  name="$(basename "$skill_dir")"
  link "${skill_dir%/}" "$HOME/.claude/skills/$name"
done

log ""
log "Done. Backups (if any) are under $BACKUP_DIR"
log "If this is a fresh Claude Code install, run 'claude' once and install the"
log "caveman and mattpocock-skills plugins listed in claude-code/settings.json."
