# rich-history

Log every shell command with timestamp + working directory to a local JSONL file. Works in zsh and bash.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/datmt/rich-history/master/install.sh | sh
```

Then restart your shell (`exec $SHELL`).

## Search

```sh
rh              # dump full history
rh some_pattern # grep-filter by substring
```

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/datmt/rich-history/master/uninstall.sh | sh
```

Add `--purge` to also delete logged history data:

```sh
curl -fsSL https://raw.githubusercontent.com/datmt/rich-history/master/uninstall.sh | sh -s -- --purge
```

## Details

- Log format: `{"ts": "2026-08-07T02:09:00Z", "dir": "/path", "cmd": "echo hi"}`
- Location: `~/.local/share/rich-history/history.jsonl` (override with `$RICH_HISTORY_FILE`)
- Requires `git` and `jq`
- Install location: `~/.rich-history` (override with `$RICH_HISTORY_HOME`)
