# OpenCode configuration

The shared OpenCode settings are in [`static/common/opencode`](../../static/common/opencode/).
Schooner's Home Manager configuration reads both JSON files from there. Its global instructions and
personal agents remain separate, in `static/hosts/Schooner/opencode/AGENTS.md` and `static/agents/`.
Run `nh home switch .` on Schooner to apply changes.

On workmbp, keep the work-specific `AGENTS.md`, `agents/`, and skills in their existing locations.
OpenCode discovers the agents from `~/.config/opencode/agents/`; the shared JSON does not define
their inventory. To use the shared settings, back up the existing global `opencode.json`,
`opencode.jsonc`, and `cli.json` if present, then create links to the dotfiles checkout. Do not
leave the old `opencode.jsonc` alongside the shared `opencode.json`: it can override the shared
configuration. If `~/.config/opencode` is itself a symlink, these operations affect its target.

```sh
DOTFILES="$HOME/path/to/dotfiles" # replace with the checkout's absolute path
ln -s "$DOTFILES/static/common/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
ln -s "$DOTFILES/static/common/opencode/cli.json" "$HOME/.config/opencode/cli.json"
```

If `XDG_CONFIG_HOME` is set, use `$XDG_CONFIG_HOME/opencode` instead of `~/.config/opencode`.
The shared configuration selects `fish`, which must be available on both machines. The TUI settings
dialog cannot write through these links; edit the shared `cli.json` in the checkout instead.
The experimental work container still copies the old work configuration files. If the global config
directory points into `workdotfiles/config/opencode`, changing those files to links outside its
build context can break the container build; the container has not been migrated.
