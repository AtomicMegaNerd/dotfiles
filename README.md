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
| Schooner      | MacOS | aarch64-darwin | unstable   | unstable     | MacBook Air  |

We use `nh` which is a wrapper around `nix` to make it easier to manage our Nix systems. See
[nix helper](https://github.com/nix-community/nh) GitHub repository for more information.

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
