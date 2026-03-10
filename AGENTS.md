# Agent Guide for this Dotfiles Repository (Nix Flake)

This repository is a Nix-based dotfiles setup used to manage multiple machines (NixOS and macOS via
nix-darwin) and user environments via Home Manager.

**RULE ONE: LLM is not allowed to modify this file.**

## Essential Commands

- Enable direnv (loads the flake dev shell via `.envrc`):
  - `direnv allow`
- Set up pre-commit hooks:
  - `pre-commit install`
  - `pre-commit run --all-files`
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
- **nix/** — Modular Home Manager and app configuration modules (imported by host home configs):
  - catppuccin.nix, claude.nix, eza.nix, fish.nix, fzf.nix, ghostty.nix, git.nix,
    hm_base.nix (base imports), lazydocker.nix, neovim.nix, nh.nix, packages.nix, starship.nix,
    xdg.nix, zellij.nix, zoxide.nix
- **config/** - Configs that are not written in nix (nvim, zellij, zed, etc).
- **scripts/** - This contains a script for Zellij that has an optimized layout for this repo.
- **static/**
  - `rcd_pub_key` — Public key used in configurations

## Flake Inputs (observed)

- **nixpkgs** (stable release-25.11) and nixpkgs-unstable
- **home-manager** (follows nixpkgs-unstable)
- **nix-darwin** (follows nixpkgs-unstable)
- **catppuccin** (theme modules, follows nixpkgs-unstable)
- **git-hooks** (pre-commit with nix, follows nixpkgs-unstable)

## Configuration Patterns and Conventions

- `xdg.nix` maps repo `config/*` directories into `~/.config/*`.
- On macOS, `hosts/Schooner/rcd.nix` additionally creates an out-of-store symlink for Zed.
- The fish shell is the default, with shared init snippet and OS-specific adjustments.
- Packages are centralized in `nix/packages.nix` and extended per-host as needed.

## Host-Specific Notes

- NixOS (hosts/blahaj/configuration.nix):
  - Enables Podman with dockerCompat and defines containers: pihole, freshrss, starfeed (depends
    on freshrss)
  - Creates an IPv6 Podman network `podman-ipv6` via a systemd oneshot service used by containers
  - Daily backup systemd timer/service for Pi-hole and FreshRSS data to `/data/backups`
  - Firewall opens ports 53 (TCP/UDP), 8080, 8081; sets Quad9 DNS nameservers
  - Nix settings enable `nix-command` and `flakes`; weekly GC
  - User `rcd` with fish shell and SSH key from `static/rcd_pub_key`
  - Note: `starfeed` container uses `environmentFiles = [ "/etc/starfeed/.env" ];` (not in repo)

- macOS (hosts/Schooner/darwin.nix):
  - nix-darwin system with `programs.fish.enable = true`
  - Homebrew management enabled with casks only
  - Touch ID for sudo enabled
  - `nix.enable = false` (managed via nix-darwin/home-manager and Homebrew)

- Home configurations (hosts/*/rcd.nix):
  - Import `nix/hm_base.nix` for shared programs, catppuccin, and xdg config

## Pre-commit and Formatting

- The flake has the list of hooks. You can just run the checks in the flake directory thusly:

```bash
pre-commit run
```

## Development Environment

- `.envrc` contains `use flake` to expose the flake dev shell automatically via direnv
- Flake devShell just sets up the pre-commit hooks with Nix.

## Gotchas and Non-obvious Details

- Hardcoded paths assume the repo lives at `$HOME/Code/Configs/dotfiles`:
  - Fish sets `NH_FLAKE` to that path
  - macOS home config uses `mkOutOfStoreSymlink` to `$HOME/Code/Configs/dotfiles/config/zed`
- Mixed nixpkgs channels:
  - NixOS host uses stable nixpkgs via `buildOsConf ... true`
  - Home and nix-darwin configurations use nixpkgs-unstable
  - Be mindful when adding modules/options that may only exist on unstable
- Container networking: New containers needing IPv6 bridge should use the `podman-ipv6` network or
  extend the `create-podman-network` service dependencies.
- Theme is Catppuccin **Macchiato** throughout — use this flavour when configuring new apps, not
  Mocha, Latte, or Frappé.
