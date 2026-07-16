# AtomicMegaNerd's NixOS Flake and Related Configs

```text
    ___   __                  _      __  ___                 _   __              __
   /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
  / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
 / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
/_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
                                             /____/
```

![AtomicMegaNerd](https://github.com/AtomicMegaNerd/AtomicMegaNerd/blob/main/img/RCD-AtomicMegaNerd-Beard-400.png)

This is my core flake for my Nix-managed machines as well as any other machines that use Nix as a
package manager. The only app which has settings not managed by nix is neovim. We have a separate
repo for that that we just clone to `~/.config/nvim`:

[https://github.com/AtomicMegaNerd/rcd-nvim](https://github.com/AtomicMegaNerd/rcd-nvim)

---

## Systems Managed By This Flake

| Host     | OS    | Platform       | OS Version | HM Version | Notes       |
| -------- | ----- | -------------- | ---------- | ---------- | ----------- |
| blahaj   | NixOS | x86-64-linux   | 26.05      | unstable   | Server      |
| Schooner | macOS | aarch64-darwin | unstable   | unstable   | MacBook Air |

We use `nh` which is a wrapper around `nix` to make it easier to manage our Nix systems. See
[nix helper](https://github.com/nix-community/nh) GitHub repository for more information.

---

## Prerequisites

The following has to be installed and setup before the rest of the guide can be followed:

- Nix has to be installed on the system. Of course on NixOS systems `nix` is pre-installed. On
  non-Nix machines use [nix-installer](https://github.com/NixOS/nix-installer).
- For the Mac we also need 1Password-CLI `op` installed to unlock the secrets (see
  [Secrets](./docs/secrets.md) and [op](https://www.1password.dev/cli)). You cannot run the
  home-manager without it unless you remove the `.tpl` templates from the config.

---

## Setup

Now we can clone the flake and run the setup. We use the following:

- Home-Manager manages dotfiles for users on a Nix managed system
  [home-manager](https://github.com/nix-community/home-manager)
- This is Nix for MacOS machines [nix-darwin](https://github.com/nix-darwin/nix-darwin)

For all systems we start by cloning the dotfiles repo and then we `cd` into it:

```bash
mkdir -p ~/Code/Configs
cd ~/Code/Configs
git clone https://github.com/AtomicMegaNerd/dotfiles
cd dotfiles
```

### Note for External Users

For external users you need to update the flake to match your infrastructure including:

- Machines
- Desired tools
- Users
- Secrets

The examples (hostnames, usernames) below are for my systems.

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

_The last step is needed so nix-darwin can replace nix.conf with its own configuration._

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

### direnv

We use [nix-direnv](https://github.com/nix-community/nix-direnv) to setup a dev shell for this repo.
It adds linters and LSP's as well as a pre-commit configuration.

To enable the `direnv` Nix shell for flake development, run the following command in the dotfiles
repo to setup the flake devshell automatically every time you cd into this project directory:

```fish
direnv allow
```

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
- [AGENTS.md](./AGENTS.md) Information for the bots.
- [LICENSE](./LICENSE) MIT license.
