# AtomicMegaNerd's NixOS Flake and Related Configs

![AtomicMegaNerd](./static/images/RCD-AtomicMegaNerd-Beard-400.png)

---

## Introduction

This is personal Nix flake for my hardware. I have gradually been improving this flake over time as I learn more and more about Nix. This flake is pretty comprehensive at this point and manages the large majority of my system configuration from a shell/TUI perspective.

### Core Nix Components

Besides NixOS itself, we use the following in this flake:

- [home-manager](https://github.com/nix-community/home-manager) manages dotfiles for users on a Nix
  managed system.
- [nix-darwin](https://github.com/nix-darwin/nix-darwin) is Nix for macOS.

### Systems Managed By This Flake

| Host     | OS    | Platform       | OS Version | HM Version | Notes              |
| -------- | ----- | -------------- | ---------- | ---------- | ------------------ |
| blahaj   | NixOS | x86_64-linux   | 26.05      | unstable   | ThinkCentre Server |
| Schooner | macOS | aarch64-darwin | unstable   | unstable   | MacBook Air        |

---

## Setup

Nix has to be installed on the system. Of course on NixOS systems `nix` is pre-installed. On non-Nix machines use [nix-installer](https://github.com/NixOS/nix-installer).

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

All systems let you use the same command to bootstrap home-manager with your flake. The example below is for blahaj:

```bash
nix run home-manager -- switch --flake .#rcd@blahaj
```

---

## Operation

Once the initial bootstrap is done you may need to start a new terminal shell or even logout and log back into the system to fully load your new shell config including the updates to the PATH.

### Nix Commands

Nix Helper is a replacement for some nix CLI commands that is better engineered and easier to use [nh](https://github.com/nix-community/nh)

> [!NOTE]
> If you add the `NH_FLAKE` enviroment variable and point it to your flake, you don't have to
> provide a path to the commands below.
>
> ```fish
> set -gx NH_FLAKE $HOME/Code/Configs/dotfiles
> ```

Use the following commands to apply configuration:

#### NixOS

```fish
nh os switch
```

#### Nix-Darwin

```fish
nh darwin switch
```

#### Home Manager

```fish
nh home switch
```

---

## Neovim

> [!NOTE]
> My Neovim configuration is in its own separate [rcd-nvim](https://github.com/AtomicMegaNerd/rcd-nvim) repo.

This flake clones my neovim config repo and deploys it to `~/.config/nvim`. See [neovim.nix](./nix/neovim.nix).

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

---

## Next Steps

Below are some ideas I want to explore for my homelab.

### Near Term

- [x] Replace `pihole` with `blocky`.
- [ ] Extract some common variables out like the container registry to use.
- [ ] Make ssh forwarding work on `Schooner`.
- [ ] See if I can send a wakeup packet to `Schooner` from rootshell.
- [ ] See if I can setup my pi 3 while I wait for the new server, just with blocky for redundancy.
- [ ] Add second server (as soon as I have the $$$)
- [ ] Test and document restore from backup for all services on [restic](/docs/infra/backups.md).
- [ ] Migrate [starfeed](https://github.com/AtomicMegaNerd/starfeed) to my [Forgejo](./docs/services/forgejo.md) instance with CI/CD while using GitHub as a mirror.

### Longer Term

> [!NOTE]
> No timeline on any of this.

- [ ] Open up some services?
  - [ ] 2FA/Oauth/both?
  - [ ] Blog?
- [ ] NixOS 26.11 upgrade on `blahaj`.
  - [ ] Podman 6 migration on `blahaj`.
- [ ] Look at migrating to the [dendritic pattern](./docs/reference/dendritic.md).
- [ ] Look at setting up posgresql
- [ ] Add second server
- [ ] Look at migrating to kubernetes (k3s?) or just using Pods in podman

## More Information

- [Services](./docs/services/services.md) Overview of services running on my homelab.
- [DNS Setup](./docs/infra/dns.md) How we setup DNS internally and externally.
- [Internal TLS](./docs/infra/tls-internal.md) Setting up trusted TLS certificates for internal services.
- [Podman](./docs/infra/podman.md) Podman network and container DNS.
- [Secrets](./docs/infra/secrets.md) Managing secrets with `agenix` and `op`.
- [Home Manager](./docs/reference/home-manager.md) Stuff I learned about `home-manager` that is worth remembering.
- [Nix Darwin](./docs/reference/nix-darwin.md) Reference information on `nix-darwin`.
- [Nix Basics](./docs/reference/nix-basics.md) I am writing down notes as I gradually learn more about how the Nix language works.
- [AGENTS.md](./AGENTS.md) Information for the bots.
- [LICENSE](./LICENSE) MIT license.
