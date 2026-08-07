#!/usr/bin/env sh
# rich-history installer
# Usage: curl -fsSL https://raw.githubusercontent.com/datmt/rich-history/master/install.sh | sh
set -eu

REPO_URL="${RICH_HISTORY_REPO:-https://github.com/datmt/rich-history.git}"
INSTALL_DIR="${RICH_HISTORY_HOME:-$HOME/.rich-history}"
BIN_DIR="$HOME/.local/bin"
MARK_START="# >>> rich-history >>>"
MARK_END="# <<< rich-history <<<"

log() { printf '%s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || die "git is required. Install it and re-run."
command -v jq  >/dev/null 2>&1 || die "jq is required. Install it (e.g. apt install jq / brew install jq) and re-run."

# fetch or update the repo
if [ -d "$INSTALL_DIR/.git" ]; then
  log "Updating existing install at $INSTALL_DIR"
  git -C "$INSTALL_DIR" pull --quiet --ff-only
else
  log "Cloning rich-history to $INSTALL_DIR"
  git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# symlink the CLIs
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/bin/rh" "$BIN_DIR/rh"
ln -sf "$INSTALL_DIR/bin/rh-import" "$BIN_DIR/rh-import"
chmod +x "$INSTALL_DIR/bin/rh" "$INSTALL_DIR/bin/rh-import"
log "Linked rh -> $BIN_DIR/rh"
log "Linked rh-import -> $BIN_DIR/rh-import"
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) log "Note: $BIN_DIR is not on your PATH. Add it to use the 'rh' command." ;;
esac

# wire a shell rc file, replacing any prior rich-history block
wire_rc() {
  rc_file="$1"
  source_line="$2"
  touch "$rc_file"
  if grep -qF "$MARK_START" "$rc_file" 2>/dev/null; then
    tmp="$(mktemp)"
    awk -v s="$MARK_START" -v e="$MARK_END" '
      $0 == s {skip=1}
      !skip {print}
      $0 == e {skip=0}
    ' "$rc_file" > "$tmp"
    mv "$tmp" "$rc_file"
  fi
  {
    printf '\n%s\n' "$MARK_START"
    printf '%s\n' "$source_line"
    printf '%s\n' "$MARK_END"
  } >> "$rc_file"
  log "Wired into $rc_file"
}

if command -v zsh >/dev/null 2>&1; then
  wire_rc "$HOME/.zshrc" "source \"$INSTALL_DIR/shell/rich-history.zsh\""
fi

if command -v bash >/dev/null 2>&1; then
  wire_rc "$HOME/.bashrc" "source \"$INSTALL_DIR/shell/rich-history.bash\""
fi

log ""
log "rich-history installed."
log "History log: \${RICH_HISTORY_FILE:-$HOME/.local/share/rich-history/history.jsonl}"
log "Search with: rh [pattern]"
log "One-time import of your existing shell history: rh-import"
log "Restart your shell (or run 'exec \$SHELL') to start logging."
