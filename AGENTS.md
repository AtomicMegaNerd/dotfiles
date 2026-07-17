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
nh darwwin switch . # Mac only
nh os switch . # NiXOS only
nh search package $PACKAGE
nh search options $PACKAGE
```

### Nix Direnv

- Uses [nix-direnv](https://github.com/nix-community/nix-direnv)

This just autoloads tha flake devShell when we cd into the flake directory.

### Agenix

- [agenix](https://github.com/ryantm/agenix)

Encrypts secrets that we can store in our flake safely.

## Repo Structure

- `flake.nix`
- `docs/` - Documentation
- `hosts/` - contains host configs
- `nix/` - rest of nix configs
- `static/` - static files like keys
- `secrets/` - agenix files

## More Information

Load these as needed:

- [README.md](./README.md)
- [DNS](./docs/dns.md)
- [Secrets](./docs/secrets.md)
