# AtomicMegaNerd's NixOS Flake and Other Dotfiles

```
    ___   __                  _      __  ___                 _   __              __
   /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
  / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
 / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
/_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
                                             /____/
```

This is my core flake for my Nix-managed machines as well as any other machines that
use Nix as a package manager. This repo also contains other configs for non-Nix systems.

## Nix Systems

| Host          | OS    | Platform       | Version   | Notes        |
| ------------- | ----- | -------------- | --------- | ------------ |
| blahaj        | NixOS | x86-64-linux   | unstable  | Server       |
| metropolitan  | NixOS | x86-64-linux   | unstable  | WSL          |
| arcology      | NixOS | x86-64-linux   | 24.11     | VMWare Guest |

### Nix System Upgrade

Run the build against the host that you are interested in. This only applies to NixOS machines:

```fish
sudo nixos-rebuild switch --flake .#
```

### Home-Manager Upgrade

We use home-manager on all of our Nix managed machines.

```fish
home-manager switch --flake .#USERNAME@HOST
```

## Windows

Configuration files for my Windows programs:

- Windows Terminal
- VSCode
- Powershell
- Neovim (shared with Nix)

To install the configs, first make sure you have the required programs installed.
Then run the following as Administrator:

```powershell
.\scripts\CreateSymlinks.ps1
```

## Environment Variables

The following environment variables are used in the different configurations:

```fish
# Set to "1" in order to enable Mason which can then manage and install
# LSP servers and linters for Neovim.
set -gx NVIM_ENABLE_MASON 1
```
