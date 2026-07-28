# AtomicMegaNerd's NixOS Flake and Related Configs

![AtomicMegaNerd](./static/images/RCD-AtomicMegaNerd-Beard-400.png)

---

## Introduction

This is personal Nix flake for my hardware. I have gradually been improving this flake over time
as I learn more and more about Nix. This flake is pretty comprehensive at this point and
manages the large majority of my system configuration from a shell/TUI perspective.

### Core Nix Components

Besides NixOS itself, we use the following in this flake:

- [home-manager](https://github.com/nix-community/home-manager) manages dotfiles for users on a Nix
  managed system.
- [nix-darwin](https://github.com/nix-darwin/nix-darwin) is Nix for macOS.

### Systems Managed By This Flake

| Host     | OS    | Platform       | OS Version | HM Version | Notes       |
| -------- | ----- | -------------- | ---------- | ---------- | ----------- |
| blahaj   | NixOS | x86-64-linux   | 26.05      | unstable   | Server      |
| Schooner | macOS | aarch64-darwin | unstable   | unstable   | MacBook Air |

---

## Setup

Nix has to be installed on the system. Of course on NixOS systems `nix` is pre-installed. On
non-Nix machines use [nix-installer](https://github.com/NixOS/nix-installer).

For all systems we start by cloning this repo and then we `cd` into it:

```bash
mkdir -p ~/Code/Configs
cd ~/Code/Configs
git clone https://github.com/AtomicMegaNerd/dotfiles
cd dotfiles
```

> [!NOTE]
> For external users you need to update the flake to match your infrastructure.

### MacOS

We need to bootstrap nix-darwin first. This will enable flake support as well.

```bash
sudo nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin -- switch --flake .#Schooner
```

If this doesn't work, enable experimental features in the config:

```bash
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
sudo mv /etc/nix/nix.conf /etc/nix/.before-darwin
```

Then try the nix command again.

> [!IMPORTANT]
> The last step is needed so nix-darwin can replace nix.conf with its own configuration.

### NixOS

```bash
sudo nix --extra-experimental-features "nix-command flakes" \
  run nixos-rebuild -- switch --flake .#blahaj
```

### Home Manager (all systems)

All systems let you use the same command to bootstrap home-manager with your flake:

```bash
nix run home-manager -- switch --flake .#rcd@blahaj
```

---

## Operation

Once the initial bootstrap is done you may need to start a new terminal shell or even logout and log
back into the system to fully load your new shell config including the updates to the PATH.

### Nix Commands

Nix Helper is a replacement for some nix CLI commands that is better engineered and easier to use
[nh](https://github.com/nix-community/nh)

#### NixOS

```fish
nh os rebuild .
```

#### Nix-Darwin

For Nix-Darwin systems, you can use the following command to rebuild the system configuration:

```fish
nh darwin rebuild .
```

#### Home Manager

We use Home Manager on all of our Nix managed machines.

```fish
nh home rebuild .
```

---

## Neovim

> [!NOTE]
> My Neovim congiguration is in its own separate repo.

I do use this flake to install neovim and to copy the config to ~/.config. However, the config
itself is written in Lua and is in its own repo in GitHub.
See [rcd-nvim](https://github.com/AtomicMegaNerd/rcd-nvim)

---

## Theming

In [options.nix](./nix/options.nix) I have an option called `amnOptions.theme`. This option can be
set to `stylix` or `catppuccin`. In the case of stylix you can choose which base16 theme to use in
[stylix.nix](./nix/stylix.nix).

The `COLOR_THEME` environment variable will be set to the current value of `amnOptions.theme`. Also
when `stylix` is active environment variables will be set from `BASE16_COLOR_00` to
`BASE16_COLOR_0F` which lets external programs set theme colors dynamically when they cannot be
configured by nix.

---

## Repository Structure

This is the structure of this repo:

- `flake.nix` - The Nix flake file that defines the NixOS, Nix Darwin, and Home Manager
  configurations.
- `docs/` - Documentation
- `hosts/` - Directory containing host-specific configurations.
- `nix/` - Directory containing Nix sources for different apps and common modules.
- `static/` - Directory containing static files used in configurations.
- `secrets/` - Managing secrets with agenix and op (1Password CLI).

Over time as more options are added to Home Manager and NixOS, more of the configuration should be
migrated to Nix.

---

## More Information

- [DNS Setup](./docs/dns.md) How we setup DNS internally and externally.
- [Secrets](./docs/secrets.md) Managing secrets with `agenix` and `op`.
- [Home Manager Docs](./docs/home-manager.md) Stuff we learned about home-manager that is worth
  remembering.
- [Nix Basics](./docs/nix-basics.md) I am writing down notes as I gradually learn more about how
  the Nix language works.
- [AGENTS.md](./AGENTS.md) Information for the bots.
- [LICENSE](./LICENSE) MIT license.
