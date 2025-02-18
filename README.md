# AtomicMegaNerd's NixOS Flake and Other Dotfiles

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
use Nix as a package manager. This repo also contains other configs for non-Nix systems.

## Nix Systems

| Host          | OS    | Platform       | OS Version | HM Version   | Notes        |
| ------------- | ----- | -------------- | ---------- | ------------ | ------------ |
| blahaj        | NixOS | x86-64-linux   | 24.11      | unstable     | Server       |
| metropolitan  | NixOS | x86-64-linux   | 24.11      | unstable     | Workstation  |
| Discovery     | MacOS | aarch64-darwin | N/A        | unstable     | MacBook Pro  |

In all NixOS instances the core OS is the latest stable release. However, we use unstable packages
for the home-manager configuration in order to keep my development tooling up-to-date.

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
