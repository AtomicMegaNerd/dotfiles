# AtomicMegaNerd's NixOS Flake

```
    ___   __                  _      __  ___                 _   __              __
   /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
  / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
 / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
/_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
                                             /____/
```

This is my core flake for my Nix-managed machines as well as any other machines that
use Nix as a package manager.

Right now we have two hosts:

| Host      | OS    | Platform       |
| --------- | ----- | -------------- |
| blahaj    | NixOS | x86-64-linux   |
| discovery | MacOS | aarch64-darwin |

## Run OS Upgrade

Run the build against the host that you are interested in. This only applies to
NixOS machines:

```bash
sudo nixos-rebuild switch --flake .#
```

## Run Home-Manager Upgrade

We use home-manager on all of our Nix managed machines.

```bash
home-manager switch -- flake .#USERNAME@HOST
```
