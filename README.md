# AtomicMegaNerd's Linux/MacOS Configs

```
    ___   __                  _      __  ___                 _   __              __
   /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
  / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
 / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
/_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
                                             /____/
```

This repository stores the dotfiles for my UNIX based systems.  The idea is
to symlink all of the configs to the git managed files in this repo.

## Supported Apps

* Alacritty
* Fish
* NeoVim
* VSCode

## Setup

This assumes that you have checked out the dotfiles in ~/Code/Configs/dotfiles.
Of course feel free to change the path in the examples below to match the
location that contains the repo.

### Alacritty

```bash
mkdir ~/.config/alacritty
cd ~/.config/alacritty
ln -s ~/Code/Configs/dotfiles/Alacritty/alacritty.yml
```

### Fish

Fish is simple.  Simply symlink the HOST folder that you want (Discovery, JebPopOS, etc).

```bash
ln -s ~/Code/Configs/dotfiles/Fish/HOST ~/.config/fish
```

### TMux

Set the tmux.conf file from the symlink:

```bash
ln -s ~/Code/Configs/dotfiles/TMux/tmux.conf ~/.tmux.conf
```

### NeoVim

If you setup fish the alias from vim to nvim should be setup already. If this
is not the case please set this up first.  This is now based on the 0.5 release as
it uses a Lua based configuration.

My NeoVim setup now uses the built-in LSP as well as many other lua based plug-ins.  This means
that my vim config is tightly coupled to Neovim.

#### Mac/Linux

I recommend homebrew for both Mac and Linux.

```bash
brew install neovim 
```

#### Common

After doing the Mac or Linux parts next install vim-plug:

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

To configure:

```bash
cd ~/.config
ln -s ~/Code/Configs/dotfiles/Neovim nvim
nvim +PackerInstall
```

### Helix

This is another text editor I am keeping an eye on.

```bash
cd ~/.config
ln -s ~/Code/Configs/dotfiles/Helix/ helix
```
