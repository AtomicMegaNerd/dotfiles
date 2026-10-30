# LLM Agent Guidance

**CRITICAL: LLM Agents are NEVER allowed to modify this file!**

Always use the `rcd-nix` agent when working with this repo.

## Main Reference Info

- Dotfiles as a Nix [flake](./flake.nix) for two hosts: `blahaj` (NixOS, `x86_64-linux`) and
  `Schooner` (macOS, `aarch64-darwin`).
- We use `nixpkgs` (stable) for NixOS but `nixpkgs-unstable` for everything else. This is
  intentional.
- The [nix-direnv](https://github.com/nix-community/nix-direnv#readme) dev shell installs pre-commit
  hooks (`nixfmt`, `yamllint`, `markdownlint-cli2`, `oxfmt`) that run on commit.

### Home Manager

Try to use home-manager modules and nix configuration whenever possible. Lots of examples in the
`nix` directory in this repo.

- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [Home Manager options](https://nix-community.github.io/home-manager/options.xhtml)
- [Our HM docs](./docs/reference/home-manager.md)

### Nix Darwin

- [nix-darwin manual](https://nix-darwin.github.io/nix-darwin/manual/)

We also install some Homebrew packages via nix-darwin. We prefer casks but formulas without
dependencies are okay as a last resort. **NOTE** home-manager and darwin are separate. One does not
update the other when `nh darwin switch .` is run.

### Nix Helper

Use [nh](https://github.com/nix-community/nh) whenever possible as it is faster and provides better
output.

```bash
nh home switch . # Home Manager (all systems)
nh darwin switch . # Mac only
nh os switch . # NixOS only
nh search package $PACKAGE
nh search options $OPTION
```

### Agenix

[agenix](https://github.com/ryantm/agenix) encrypts secrets so they can be stored in the flake. See
[secrets.md](./docs/infra/secrets.md).

## Repo Structure

- `flake.nix`
- `docs/` - Documentation
- `hosts/` - Host configs
- `nix/` - Shared nix configs
- `static/` - Static files like keys and static configs
- `secrets/` - agenix files

## Notes

### Podman

Services run as Podman containers on blahaj on Podman's default dual-stack network and reach each other by container name. Caddy reverse proxy handles TLS termination for internal hostnames.

- [Podman](./docs/infra/podman.md) - Container setup using `podman`.
- [Internal TLS](./docs/infra/tls-internal.md) - Certificate generation and Caddy configuration

### OpenCode

[OpenCode docs](https://opencode.ai/docs/). Config lives in `static/opencode/` as vanilla configs:
`opencode.json`, `cli.json`, and `AGENTS.md`. `nix/opencode.nix` imports them with
`mutableSettings = true`, so Home Manager owns the declarative layers while OpenCode can still
mutate the runtime `~/.config/opencode/*.json` files.

`nix/fish.nix` sets `OPENCODE_CONFIG` and `OPENCODE_CLI_CONFIG_CONTENT` to point OpenCode at
home-manager's generated configs.

See [opencode.nix](./nix/opencode.nix) and [fish.nix](./nix/fish.nix).

### Rift

[Rift docs](https://acsandmann.github.io/rift-docs/). A tiling window manager for macOS. See
[rift.nix](./nix/rift.nix).

### Claude Code

[Claude Code docs](https://code.claude.com/docs/en/overview). Configured with `programs.claude-code`
and `mutableSettings = true`. Sources:

- `static/claude-code/CLAUDE.md` - global context
- `static/claude-code/settings.json` - settings
- `static/agents/` - subagents (`rcd-go`, `rcd-nix`)

Telemetry is disabled by environment variables in `nix/fish.nix`. See
[claude-code.nix](./nix/claude-code.nix).

### Herdr

[Herdr docs](https://herdr.dev/docs/). Terminal multiplexer for coding agents, configured with
`programs.herdr`. See [herdr](./docs/tools/herdr.md) and [herdr.nix](./nix/herdr.nix).

### Catppuccin Theming

[catppuccin/nix docs](https://github.com/catppuccin/nix/tree/main/docs). Flavor and accent are set
once in `nix/options.nix` as `amnOptions.catppuccin.*`. It also exposes a `palette` attrset for
programs without a Catppuccin module. Neovim is excluded because it manages its own theme. See
[options.nix](./nix/options.nix) and [catppuccin.nix](./nix/catppuccin.nix).

### Neovim

[Neovim docs](https://neovim.io/doc/). The Neovim config is **not** in this repo. It lives in
[rcd-nvim](https://github.com/AtomicMegaNerd/rcd-nvim) and an activation script in
[neovim.nix](./nix/neovim.nix) clones it to `~/Code/Configs/rcd-nvim` and symlinks it to
`~/.config/nvim`.

### Shells

[Fish docs](https://fishshell.com/docs/current/) and [Nushell book](https://www.nushell.sh/book/).
Fish is the primary shell, but Nushell is also configured. They duplicate their environment
variables and PATH setup, so keep [fish.nix](./nix/fish.nix) and [nushell.nix](./nix/nushell.nix) in
sync.

### Agent Skills

Skills are listed in `nix/agent-skills.nix` and installed to `~/.agents/skills/` by the
[skills](https://skills.sh/docs) CLI during Home Manager activation. `~/.agents/skills/` is
symlinked to `~/.claude/skills` for Claude Code.

### Beszel

The Beszel Hub runs on blahaj. We have agents on blahaj and on its vm's. Caddy serves the Hub at `monitor.megaparsec.ca`. Beszel can notify about service failures while blahaj is running, but cannot notify if the host is offline.

- [Beszel](./docs/services//beszel.md) - Hub, Agent, and alert setup
- [Services](./docs/services/services.md) - Caddy routes

### Forgejo

Forgejo runs as a rootless Podman image at `git.megaparsec.ca`. Its Actions runner runs in a microVM (nixos-unstable guest) on a NAT bridge, `vm-bridge`, separate from the Podman network. The host's network values are defined in the `let` block of `configuration.nix` and passed into the runner module.

- [Forgejo](./docs/services/forgejo.md) - Server, runner VM, and networking

## More Information

- [README.md](./README.md)
- [Internal TLS](./docs/infra/tls-internal.md)
- [DNS](./docs/infra/dns.md)
- [Secrets](./docs/infra/secrets.md)
