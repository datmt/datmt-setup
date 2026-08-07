#!/usr/bin/env sh
# rich-history uninstaller
# Usage: curl -fsSL https://raw.githubusercontent.com/datmt/rich-history/master/uninstall.sh | sh
# Add --purge to also delete logged history data.
set -eu

INSTALL_DIR="${RICH_HISTORY_HOME:-$HOME/.rich-history}"
BIN_DIR="$HOME/.local/bin"
DATA_FILE="${RICH_HISTORY_FILE:-$HOME/.local/share/rich-history/history.jsonl}"
MARK_START="# >>> rich-history >>>"
MARK_END="# <<< rich-history <<<"
PURGE=0

for arg in "$@"; do
  [ "$arg" = "--purge" ] && PURGE=1
done

log() { printf '%s\n' "$*"; }

unwire_rc() {
  rc_file="$1"
  [ -f "$rc_file" ] || return 0
  grep -qF "$MARK_START" "$rc_file" 2>/dev/null || return 0
  tmp="$(mktemp)"
  awk -v s="$MARK_START" -v e="$MARK_END" '
    $0 == s {skip=1; next}
    $0 == e {skip=0; next}
    !skip {print}
  ' "$rc_file" > "$tmp"
  mv "$tmp" "$rc_file"
  log "Removed hook from $rc_file"
}

unwire_rc "$HOME/.zshrc"
unwire_rc "$HOME/.bashrc"

for cli in rh rh-import; do
  if [ -L "$BIN_DIR/$cli" ] || [ -e "$BIN_DIR/$cli" ]; then
    rm -f "$BIN_DIR/$cli"
    log "Removed $BIN_DIR/$cli"
  fi
done

if [ -d "$INSTALL_DIR" ]; then
  rm -rf "$INSTALL_DIR"
  log "Removed $INSTALL_DIR"
fi

if [ "$PURGE" -eq 1 ]; then
  if [ -f "$DATA_FILE" ]; then
    rm -f "$DATA_FILE"
    log "Purged history data: $DATA_FILE"
  fi
else
  [ -f "$DATA_FILE" ] && log "Kept history data: $DATA_FILE (re-run with --purge to delete)"
fi

log ""
log "rich-history uninstalled. Restart your shell (or run 'exec \$SHELL')."
