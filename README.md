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
use Nix as a package manager. This repo also contains other dotfiles for non-Nix systems.

Right now we have two hosts that are managed by Nix:

| Host      | OS    | Platform       |
| --------- | ----- | -------------- |
| spork     | NixOS | x86-64-linux   |
| blahaj    | NixOS | x86-64-linux   |
| discovery | MacOS | aarch64-darwin |

## Run OS Upgrade

Run the build against the host that you are interested in. This only applies to NixOS machines:

```bash
sudo nixos-rebuild switch --flake .#
```

## Run Home-Manager Upgrade

We use home-manager on all of our Nix managed machines.

```bash
home-manager switch -- flake .#USERNAME@HOST
```

## Legacy Non-Nix Configurations

The following are instructions fro configuring your dotfiles on non-Nix systems:

### Alacritty

```bash
ln -s ~/Code/Configs/dotfiles/legacy/Alacritty/HOST/ ~/.config/alacritty
```

### Fish

Fish is simple. Simply symlink the HOST folder that you want (Discovery, JebPopOS, etc).

```bash
ln -s ~/Code/Configs/dotfiles/legacy/Fish/HOST ~/.config/fish
```

### TMux

Set the tmux.conf file from the symlink:

```bash
ln -s ~/Code/Configs/dotfiles/common/tmux/tmux.conf ~/.tmux.conf
```

### NeoVim

For non-nix systems set the environment variable:

```bash
AMN_INSTALL_TYPE="non-nix"
```

Then after installing Neovim you can symlink the configuration:

```bash
ln -s ~/Code/Configs/dotfiles/common/nvim ~/.config/nvim
```

When you first load Neovim run :PackerSync to install all the plug-ins.

### Helix

This is another text editor I am keeping an eye on.

```bash
cd ~/.config
ln -s ~/Code/Configs/dotfiles/legacy/Helix/ helix
```

### Powershell

To use this Powershell configuration in Windows you need to install a few modules with scoop first:

```pwsh
scoop bucket add extras
scoop install oh-my-posh
scoop install terminal-icons
```

Then create the symlink (needs Administrator on Windows):

```pwsh
cd C:\Users\chris\Documents\PowerShell
New-item -ItemType SymbolicLink -Target C:\Users\chris\Code\Configs\dotfiles\Powershell\Microsoft.PowerShell_profile.ps1 Microsoft.PowerShell_profile.ps1
```
