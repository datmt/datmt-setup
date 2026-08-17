#!/usr/bin/env bash
# rich-history: log every command with timestamp + cwd to a JSONL file (bash).
# Note: dir logged is $PWD after the command runs (bash has no true preexec
# hook without a DEBUG trap, which misfires on pipelines/subshells).

: "${RICH_HISTORY_FILE:=$HOME/.local/share/rich-history/history.jsonl}"
mkdir -p "$(dirname "$RICH_HISTORY_FILE")"

_rich_history_log() {
  local line idx cmd
  line="$(HISTTIMEFORMAT= builtin history 1)"
  line="${line#"${line%%[![:space:]]*}"}"
  idx="${line%%[^0-9]*}"
  [[ -z "$idx" || "$idx" == "${_RICH_HISTORY_LAST_IDX:-}" ]] && return
  _RICH_HISTORY_LAST_IDX="$idx"
  cmd="${line#"$idx"}"
  cmd="${cmd#"${cmd%%[![:space:]]*}"}"
  [[ -z "$cmd" ]] && return
  jq -cn --arg ts "$(date -u +%FT%TZ)" --arg dir "$PWD" --arg cmd "$cmd" \
    '{ts: $ts, dir: $dir, cmd: $cmd}' >> "$RICH_HISTORY_FILE"
}

case "$PROMPT_COMMAND" in
  *_rich_history_log*) ;;
  *) PROMPT_COMMAND="_rich_history_log${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

alias history=rh
