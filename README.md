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

## Nix Systems

| Host     | OS    | Platform       | OS Version | HM Version | Notes       |
| -------- | ----- | -------------- | ---------- | ---------- | ----------- |
| blahaj   | NixOS | x86-64-linux   | 25.11      | unstable   | Server      |
| Schooner | MacOS | aarch64-darwin | unstable   | unstable   | MacBook Air |

We use `nh` which is a wrapper around `nix` to make it easier to manage our Nix systems. See
[nix helper](https://github.com/nix-community/nh) GitHub repository for more information.

## Prerequisites

- Nix has to be installed on the system. Of course on NixOS systems `nix` is pre-installed.
- [Home Manager](https://github.com/nix-community/home-manager) also needs to be installed.
- If you have [Zellij](https://zellij.dev/) installed you can also use it to make development of
  these dotfiles even easier.

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

To enable the `direnv` Nix shell for flake development, run the following command in the dotfiles
repo:

```fish
direnv allow
```

The flake will automatically setup the pre-commit hooks.

Also if `zellij` is installed you can launch neovim and a pair of shells thusly:

```fish
./scripts/zellij.sh
```

The zellij KDL configuration is found at `./.zellij/dotfiles.kdl`.

## Repository Structure

This is the structure of this repo:

- `flake.nix` - The Nix flake file that defines the NixOS, Nix Darwin, and Home Manager
  configurations.
- `hosts/` - Directory containing host-specific configurations.
- `nix/` - Directory containing Nix sources for different apps and common modules.
- `static/` - Directory containing static files used in configurations.

Over time as more options are added to Home Manager and NixOS, more of the configuration should be
migrated to Nix.

## Secrets

Secrets are managed differently per host:

### blahaj

Uses [agenix](https://github.com/ryantm/agenix) with age-encrypted files in `secrets/`. To edit a
secret:

```bash
agenix -e secrets/<name>.age
```

The `.age` files are encrypted in git.

#### Host Key Backup and Recovery

Agenix uses the host's SSH key to encrypt secrets. If you need to rebuild blahaj from scratch, you
must restore the host's private SSH key before running `nh os rebuild .` so agenix can decrypt the
secrets.

Read the keys from 1Password into files:

```bash
op read op://Private/Blahaj\ Host\ Key/private\ key > ssh_host_ed25519_key
op read op://Private/Blahaj\ Host\ Key/public\ key > ssh_host_ed25519_key.pub
```

Copy them to `blahaj` and delete the local copies:

```bash
scp ssh_host_ed25519_key* blahaj:~
rm ssh_host_ed25519_key*
```

Login to Blahaj and then run:

```bash
sudo mkdir -p /etc/ssh
sudo mv ~/ssh_host_ed25519_key* /etc/ssh
sudo chmod 600 /etc/ssh/ssh_host_ed25519_key
```

Now run `nh os rebuild .` — agenix will be able to decrypt the secrets

##### Lost Key

**If you lose the key:** You can generate a new host key and re-encrypt the secrets by updating
`static/blahaj_host_key` with the new public key and running `agenix rekey`.

### Schooner

We use op to write any secrets that we want to be user-wide environment variables. For example:

Edit the file `./secrets/credentials.fish.tpl`:

```fish
set -gx CONTEXT7_API_KEY "op://Private/Context7/api-key"
```

When we run `nh home switch .` we will have to authenticate to `op` after which it will write the
secrets to `~/.config/fish/conf.d/credentials.fish`.

**IMPORTANT** the file `~/.config/fish/conf.d/credentials.fish` **MUST** be in `.gitignore`!

## License

See the [LICENSE](./LICENSE) file for details.

## More Information

The [AGENTS.md](./AGENTS.md) file contains more information.
