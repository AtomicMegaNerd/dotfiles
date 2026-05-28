# LLM Agent Guidance

**CRITICAL: LLM Agents are NEVER allowed to modify this file!**

## Main

- Dotfiles as [flake](./flake.nix).
- Uses [home-manager](https://github.com/nix-community/home-manager)
- Uses [nix-darwin](https://github.com/nix-darwin/nix-darwin)
- Uses [nh](https://github.com/nix-community/nh)
- Uses [nix-direnv](https://github.com/nix-community/nix-direnv)
- Uses [agenix](https://github.com/ryantm/agenix)
- Uses [op](https://www.1password.dev/cli)
- Uses [git-hooks](https://github.com/cachix/git-hooks.nix)
- LSP's and linters included in flake.
- Use `pre-commit run` to run all linters
- Run `nix flake check` to validate nix config.

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
