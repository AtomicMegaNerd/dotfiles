# Agent Guide for this Dotfiles Repository (Nix Flake)

This repository is a Nix-based dotfiles setup used to manage multiple machines (NixOS and macOS via
nix-darwin) and user environments via Home Manager.

**CRITICAL: LLM is not allowed to modify this file!**

## Essential Commands

- Enable direnv (loads the flake dev shell via `.envrc`):
  - `direnv allow`
- Set up pre-commit hooks:
  - `pre-commit install`
  - `pre-commit run --all-files` (this runs all lints too use this)
- Rebuild systems with nh (nix helper):
  - NixOS: `nh os rebuild .`
  - nix-darwin (macOS): `nh darwin rebuild .`
  - Home Manager: `nh home rebuild .`

## Repository Structure

- **flake.nix** — Defines inputs and outputs for:
  - **nixosConfigurations** (e.g., blahaj)
  - **darwinConfigurations** (e.g., Schooner)
  - **homeConfigurations** (e.g., rcd@blahaj, rcd@Schooner)
  - **devShells** (sets up pre-commit for validation)
- **hosts/**
  - **blahaj/** — NixOS host (configuration.nix, hardware-configuration.nix, rcd.nix)
  - **Schooner/** — macOS host for nix-darwin (darwin.nix, rcd.nix)
- **nix/** — Modular Home Manager and app configuration modules (imported by host home configs)
- **static/**
  - `rcd_pub_key` — Public key used in configurations

## Development Environment

- `.envrc` contains `use flake` to expose the flake dev shell automatically via direnv
- Flake devShell just sets up the pre-commit hooks with Nix.

## Gotchas and Non-obvious Details

- Hardcoded paths assume the repo lives at `$HOME/Code/Configs/dotfiles`:
  - Fish sets `NH_FLAKE` to that path
- Mixed nixpkgs channels:
  - NixOS host uses stable nixpkgs via `buildOsConf`
  - Home and nix-darwin configurations use nixpkgs-unstable
  - Be mindful when adding modules/options that may only exist on unstable
- Container networking: New containers needing IPv6 bridge should use the `podman-ipv6` network or
  extend the `create-podman-network` service dependencies.
- Theme is Catppuccin **Macchiato** throughout — use this flavour when configuring new apps, not
  Mocha, Latte, or Frappé.
