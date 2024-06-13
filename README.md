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

Right now we have three hosts that are managed by Nix:

| Host          | OS    | Platform       |
| ------------- | ----- | -------------- |
| metropolitan  | NixOS | x86-64-linux   |
| blahaj        | NixOS | x86-64-linux   |
| discovery     | MacOS | aarch64-darwin |

### Nix System Upgrade

Run the build against the host that you are interested in. This only applies to NixOS machines:

```bash
sudo nixos-rebuild switch --flake .#
```

### Home-Manager Upgrade

We use home-manager on all of our Nix managed machines.

```bash
home-manager switch -- flake .#USERNAME@HOST
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

- NVIM_ENABLE_MASON - Set to "1" in order to enable Mason which can then manage and install
  different LSP's and linters for Neovim.
