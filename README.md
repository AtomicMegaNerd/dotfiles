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

### Setting Up Symlinks

#### Powershell

```powershell
New-Item -ItemType SymbolicLink -Target C:\Users\RCD\Code\Configs\dotfiles\config\Powershell\Microsoft.PowerShell_profile.ps1 -Path C:\Users\RCD\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

#### VSCode

```powershell
New-Item -ItemType SymbolicLink -Target C:\Users\RCD\Code\Configs\dotfiles\configs\VSCode\settings.json -Path C:\Users\RCD\AppData\Roaming\Code\User\settings.json
```

#### Windows Terminal

The tricky aspect here is we have to delete the settings.json first.

```powershell
New-Item -ItemType SymbolicLink -Target C:\Users\RCD\Code\Configs\dotfiles\configs\WindowsTerminal\settings.json -Path C:\Users\RCD\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

#### Neovim

```powershell
New-Item -ItemType SymbolicLink -Target C:\Users\RCD\Code\Configs\dotfiles\configs\Neovim -Path C:\Users\RCD\AppData\Local\nvim
```
