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

This is my core flake for my Nix-managed machines as well as any other machines that
use Nix as a package manager. This repo also contains configurations for apps that
are installed by my flake but configured externally (i.e. Neovim).

## Nix Systems

| Host          | OS    | Platform       | OS Version | HM Version   | Notes        |
| ------------- | ----- | -------------- | ---------- | ------------ | ------------ |
| blahaj        | NixOS | x86-64-linux   | 24.11      | unstable     | Server       |
| Schooner      | MacOS | aarch64-darwin | unstable   | unstable     | MacBook Air  |

We use `nh` which is a wrapper around `nix` to make it easier to manage our Nix systems. See
[nix helper](https://github.com/nix-community/nh) GitHub repository for more information.

## Getting Started

Clone this repo to get started:

```fish
git clone https://github.com/AtomicMegaNerd/dotfiles.git
cd dotfiles
```

To enable the `direnv` Nix shell for flake development, run the following command in the dotfiles repo:

```fish
direnv allow
```

### Nix OS Upgrade

Run the build against the host that you are interested in. This only applies to NixOS machines:

```fish
nh os rebuild .
```

### Nix-Darwin Upgrade

For Nix-Darwin systems, you can use the following command to rebuild the system configuration:

```fish
nh darwin rebuild .
```

### Home-Manager Upgrade

We use home-manager on all of our Nix managed machines.

```fish
nh home rebuild .
```

## Repository Structure

This is the structure of this repo:

- `flake.nix` - The Nix flake file that defines the NixOS, Nix-Darwin, and
  Home-Manager configurations.
- `hosts/` - Directory containing host-specific configurations.
- `nix/` - Directory containing Nix sources for different apps and common modules.
- `config/` - Directory containing non-nix configurations.
- `static/` - Directory containing static files used in configurations.

Over time as more options are added to home-manager and nixos, more of the configuration should be migrated to Nix.
