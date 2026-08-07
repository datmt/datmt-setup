#!/usr/bin/env zsh
# rich-history: log every command with timestamp + cwd to a JSONL file (zsh).

: "${RICH_HISTORY_FILE:=$HOME/.local/share/rich-history/history.jsonl}"
mkdir -p "${RICH_HISTORY_FILE:h}"

_rich_history_log() {
  local cmd="$1"
  [[ -z "$cmd" ]] && return
  jq -cn --arg ts "$(date -u +%FT%TZ)" --arg dir "$PWD" --arg cmd "$cmd" \
    '{ts: $ts, dir: $dir, cmd: $cmd}' >> "$RICH_HISTORY_FILE"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _rich_history_log

alias history=rh
