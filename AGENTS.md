# LLM Agent Guidance

**CRITICAL: LLM Agents are NEVER allowed to modify this file!**

## Main Reference Info

- Dotfiles as Nix [flake](./flake.nix).
- Run `nix flake check` to validate nix config.
- We use `nixpkgs` (stable) for nixos but `nixpkgs-unstable` for everything else. This is
  intentional.

We use the following components:

### Home Manager

- [home-manager](https://github.com/nix-community/home-manager)
- [Our HM docs](./docs/home-manager.md)

Try to use home-manager modules and nix configuration whenever possible. Lots of examples in the
`nix` directory in this repo.

### Nix Darwin

- [nix-darwin](https://github.com/nix-darwin/nix-darwin)

We also do install some Homebrew packages via nix-darwin but limit them to casks only.

### Nix Helper

- Uses [nh](https://github.com/nix-community/nh)

```bash
nh home switch . # Home Manager (all systems)
nh darwin switch . # Mac only
nh os switch . # NiXOS only
nh search package $PACKAGE
nh search options $PACKAGE
```

### Agenix

- [agenix](https://github.com/ryantm/agenix)

Encrypts secrets that we can store in our flake safely.

## Repo Structure

- `flake.nix`
- `docs/` - Documentation
- `hosts/` - contains host configs
- `nix/` - rest of nix configs
- `static/` - static files like keys and static configs
- `secrets/` - agenix files

## Notes

### OpenCode

OpenCode config lives in `static/opencode/` as vanilla configs: `opencode.json`, `cli.json`, and
`AGENTS.md`. `nix/opencode.nix` imports them with:

```nix
{
  mutableSettings = true;
};
```

Home Manager owns the declarative layers while OpenCode can still mutate the runtime
`~/.config/opencode/*.json` files.

## Agent Skills

Agent skills are listed in `nix/agent-skills.nix` and installed to `~/.agents/skills/` by the
[skills](https://skills.sh/docs) CLI during Home Manager activation. We also symlink
`~/.agents/skills/` to `~/.claude/skills` to support Claude Code.

## More Information

- [README.md](./README.md)
- [DNS](./docs/dns.md)
- [Secrets](./docs/secrets.md)
