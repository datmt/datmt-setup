# rich-history

Log every shell command with timestamp + working directory to a local JSONL file. Works in zsh and bash.

> **Warning:** Commands are stored **in plaintext, unencrypted**, on disk (`~/.local/share/rich-history/history.jsonl`). Anything you type — including secrets pasted inline (API keys, tokens, passwords in `curl`/`export`/connection strings) — is captured verbatim and kept indefinitely. There is no redaction, filtering, or encryption. Treat this file like you'd treat `.bash_history`: readable by anyone with access to your account, and worth excluding from backups/sync targets you don't fully trust. Review before sharing, backing up, or committing anything derived from it.
>
> `rh-import` backfills your *entire* existing shell history (potentially years of commands) in one shot — same plaintext exposure applies retroactively. Check what you're importing if your history contains sensitive commands.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/datmt/datmt-setup/rich-history/master/install.sh | sh
```

Then restart your shell (`exec $SHELL`).

### Import existing history (optional, one-time)

The log starts empty at install — `history`/`rh` won't show commands you ran before installing. Backfill from your shell's native history file:

```sh
rh-import                    # auto-detects ~/.zsh_history or ~/.bash_history
rh-import /path/to/histfile  # or point at one explicitly
```

Imported entries have no known working directory (native history doesn't record it) and are tagged `"imported": true`.

## Search

```sh
rh              # dump full history
rh some_pattern # grep-filter by substring
rh 20           # last 20 entries
rh -d 42        # delete entry 42 (1-indexed, oldest first)
rh -c           # clear the entire log
history         # aliased to rh — same as above
```

`rh` is not a full drop-in for `history` — it covers search, tail, delete-by-index, and clear. Flags like `-a`/`-r`/`-w` (file read/write/append) and in-place editing aren't supported.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/datmt/datmt-setup/rich-history/master/uninstall.sh | sh
```

Add `--purge` to also delete logged history data:

```sh
curl -fsSL https://raw.githubusercontent.com/datmt/datmt-setup/rich-history/master/uninstall.sh | sh -s -- --purge
```

## Details

- Log format: `{"ts": "2026-08-07T02:09:00Z", "dir": "/path", "cmd": "echo hi"}`
- Location: `~/.local/share/rich-history/history.jsonl` (override with `$RICH_HISTORY_FILE`)
- Requires `git` and `jq`
- Install location: `~/.rich-history` (override with `$RICH_HISTORY_HOME`)
- `history` is aliased to `rh` in both shells. The shell's native history builtin still works internally (logging uses `builtin history` in bash) — only the `history` command you type is overridden.
