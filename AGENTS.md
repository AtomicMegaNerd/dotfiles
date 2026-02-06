# Agent Guide for this Dotfiles Repository (Nix Flake)

This repository is a Nix-based dotfiles setup used to manage multiple machines (NixOS and macOS via nix-darwin) and user environments via Home Manager.

## Essential Commands

- Enable direnv (loads the flake dev shell via `.envrc`):
  - direnv allow
- Set up pre-commit hooks:
  - pre-commit install
  - pre-commit run --all-files
- Rebuild systems with nh (nix helper):
  - NixOS: nh os rebuild .
  - nix-darwin (macOS): nh darwin rebuild .
  - Home Manager: nh home rebuild .

## Repository Structure

- flake.nix — Defines inputs and outputs for:
  - nixosConfigurations (e.g., blahaj)
  - darwinConfigurations (e.g., Schooner)
  - homeConfigurations (e.g., rcd@blahaj, rcd@Schooner)
  - devShells (tools for development: cabal-install, ghc, stylua, lua-language-server)
- hosts/
  - blahaj/ — NixOS host (configuration.nix, hardware-configuration.nix, rcd.nix)
  - Schooner/ — macOS host for nix-darwin (darwin.nix, rcd.nix)
- nix/ — Modular Home Manager and app configuration modules (imported by host home configs):
  - hm_common.nix — Aggregates commonly enabled programs (fish, neovim, zellij, starship, eza, bat, fzf, zoxide, nh, git, direnv, bottom)
  - Individual program modules: fish.nix, neovim.nix, zellij.nix, starship.nix, eza.nix, bat.nix, fzf.nix, zoxide.nix, nh.nix, git.nix, direnv.nix, bottom.nix
  - UI/theme and app modules: catppuccin.nix, ghostty.nix
  - xdg.nix — XDG config file mappings to the repo’s config directory
  - packages.nix — Common user packages list
  - nvim/, zellij/, posting/, zed/ — Non-Nix app configuration directories used by xdg or explicit symlinks
- static/
  - rcd_pub_key — Public key used in configurations

## Flake Inputs (observed)

- nixpkgs (stable release-25.11) and nixpkgs-unstable
- home-manager (follows nixpkgs-unstable)
- nix-darwin (follows nixpkgs-unstable)
- catppuccin (theme modules)
- charm (Charm NUR for crush)
- flake-utils

## Configuration Patterns and Conventions

- Home Manager modules under `nix/*.nix` typically expose an attribute set with `enable = true;` and optional `settings` and `enableFishIntegration` keys.
- Common Home Manager config is composed via `nix/hm_common.nix` and merged into per-host home configs.
- xdg.nix maps repo `config/*` directories into `~/.config/*`. On macOS, `hosts/Schooner/rcd.nix` additionally creates an out-of-store symlink for Zed:
  - xdg.configFile = import ../../nix/xdg.nix;
  - file.".config/zed".source = mkOutOfStoreSymlink(.../config/zed)
- The fish shell is the default, with shared init snippet and OS-specific adjustments (PATH additions, NODE_OPTIONS on macOS due to a Zed issue).
- Catppuccin theme is enabled with flavor "macchiato" and accent "sky".
- Ghostty uses `pkgs.ghostty-bin` with specific font settings.
- Packages are centralized in `nix/packages.nix` and extended per-host as needed.

## Host-Specific Notes

- NixOS (hosts/blahaj/configuration.nix):
  - Enables Podman with dockerCompat and defines containers: pihole, freshrss, starfeed (depends on freshrss)
  - Creates an IPv6 Podman network `podman-ipv6` via a systemd oneshot service used by containers
  - Daily backup systemd timer/service for Pi-hole and FreshRSS data to `/data/backups`
  - Firewall opens ports 53 (TCP/UDP), 8080, 8081; sets Quad9 DNS nameservers
  - Nix settings enable `nix-command` and `flakes`; weekly GC
  - User `rcd` with fish shell and SSH key from `static/rcd_pub_key`
  - Note: `starfeed` container uses `environmentFiles = [ "/etc/starfeed/.env" ];` (not in repo)

- macOS (hosts/Schooner/darwin.nix):
  - nix-darwin system with `programs.fish.enable = true`
  - Homebrew management enabled with casks including 1password, amethyst, raycast, zoom, obsidian, calibre, zed
  - Touch ID for sudo enabled
  - `nix.enable = false` (managed via nix-darwin/home-manager and Homebrew)

- Home configurations (hosts/*/rcd.nix):
  - Import `nix/hm_common.nix` and program-specific modules; include catppuccin and xdg mappings
  - macOS home adds fonts and `claude-code`/`podman-compose` packages, and sets SSH config/allowed_signers from static key

## Pre-commit and Formatting

- Pre-commit hooks configured:
  - trailing-whitespace, end-of-file-fixer, mixed-line-ending
  - check-yaml, check-toml, check-json
  - stylua (via StyLua)
  - nixfmt
- Commands:
  - pre-commit install
  - pre-commit run --all-files

## Development Environment

- `.envrc` contains `use flake` to expose the flake dev shell automatically via direnv
- Flake devShell (per-system via flake-utils) includes: cabal-install, ghc, stylua, lua-language-server

## Gotchas and Non-obvious Details

- Hardcoded paths assume the repo lives at `$HOME/Code/Configs/dotfiles`:
  - Fish sets `NH_FLAKE` to that path
  - macOS home config uses `mkOutOfStoreSymlink` to `$HOME/Code/Configs/dotfiles/config/zed`
  - If cloning elsewhere, update these references accordingly
- Mixed nixpkgs channels:
  - NixOS host uses stable nixpkgs via `buildOsConf ... true`
  - Home and nix-darwin configurations use nixpkgs-unstable
  - Be mindful when adding modules/options that may only exist on unstable
- Secrets/keys: `static/rcd_pub_key` is public; avoid committing private keys or secrets. Containers may reference external files (e.g., `/etc/starfeed/.env`).
- Container networking: New containers needing IPv6 bridge should use the `podman-ipv6` network or extend the `create-podman-network` service dependencies.

## How to Extend

- Add a new host:
  - Create `hosts/<Host>/` with appropriate files (`configuration.nix` for NixOS, `darwin.nix` for macOS, and `rcd.nix` for Home Manager)
  - Wire it in `flake.nix` using the existing helpers: `buildOsConf`, `buildDarwinConf`, `buildHomeMgrConf`
- Add or tweak program configs:
  - Create or edit modules under `nix/*.nix` following the pattern: `{ pkgs, ... }: { enable = true; <settings> = ...; }`
  - Import via `nix/hm_common.nix` or directly in `hosts/*/rcd.nix`
- App configs under `config/` are mapped via `nix/xdg.nix` or explicit symlinks in host home configs

## Observability/Validation

- No test suite exists in this repo
- Validate changes via `nh` rebuild commands listed above
- Formatting and basic linting enforced by pre-commit hooks
