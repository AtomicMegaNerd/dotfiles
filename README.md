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
| blahaj        | NixOS | x86-64-linux   | 25.05      | unstable     | Server       |
| Schooner      | MacOS | aarch64-darwin | unstable   | unstable     | MacBook Air  |

We use `nh` which is a wrapper around `nix` to make it easier to manage our Nix systems. See
[nix helper](https://github.com/nix-community/nh) GitHub repository for more information.

## Prerequisites

Nix has to be installed on the system. On macOS I use the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer).
Of course on NixOS systems `nix` is pre-installed. [Home Manager](https://github.com/nix-community/home-manager)
also needs to be installed. If you have [Zellij](https://zellij.dev/) installed you can also use
it to make development of these dotfiles even easier.

## Getting Started

Clone this repo to get started:

```fish
git clone https://github.com/AtomicMegaNerd/dotfiles.git
cd dotfiles
```


### Nix Commands

Run the build against the host that you are interested in. For NixOS machines:

```fish
nh os rebuild .
```

For Nix-Darwin systems, you can use the following command to rebuild the system configuration:

```fish
nh darwin rebuild .
```

We use Home Manager on all of our Nix managed machines.

```fish
nh home rebuild .
```

## Development

To enable the `direnv` Nix shell for flake development, run the following command in the dotfiles repo:

```fish
direnv allow
```

To get pre-commit setup for the first time, you may need to run:

```fish
pre-commit install
```

Note that `direnv` must be installed before this can be done. It is included in the flake.

Also if `zellij` is installed you can launch neovim and a pair of shells thusly:

```fish
./scripts/zellij.sh
```

The zellij KDL configuration is found at `./.zellij/dotfiles.kdl`.

## Repository Structure

This is the structure of this repo:

- `flake.nix` - The Nix flake file that defines the NixOS, Nix Darwin, and
  Home Manager configurations.
- `hosts/` - Directory containing host-specific configurations.
- `nix/` - Directory containing Nix sources for different apps and common modules.
- `config/` - Directory containing non-Nix configurations.
- `static/` - Directory containing static files used in configurations.

Over time as more options are added to Home Manager and NixOS, more of the configuration should be
migrated to Nix.

## Secrets as Environment variables

The file `~/.config/fish/conf.d/credentials.fish` will not be stored in Git so put any secrets
in there as environment variables. MCP servers for github and context7 need the following
environment variables to be set:

```fish
set -gx CONTEXT7_API_KEY ""
set -gx GITHUB_PERSONAL_ACCESS_TOKEN ""
```

This repository is configured to make use of these secrets.

## License

See the [LICENSE](./LICENSE) file for details.

## More Information

The [AGENTS.md](./AGENTS.md) file contains more information.
