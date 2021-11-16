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
* Xmonad with XMobar
* VSCode
* Sublime Text

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

Fish is simple.  Simply symlink the HOST folder that you want (Roflania, JebPopOS, etc).

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

### Sublime Text 3

Please make sure that Package Control is installed first.  Sadly there is
a problem where the font_size configuration will need to be different on
Linux than on MacOS so you'll need to set a different number there unless
you like really giant sized text on Linux.

#### Mac (Roflania)

If nodejs is not already installed....

```bash
brew install node
```

```bash
cd /Users/chris/Library/Application Support/Sublime Text 3/Packages/User
ln -s ~/Code/Configs/dotfiles/Sublime/Roflania/LSP.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/Roflania/Package\ Control.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/Roflania/Preferences.sublime-settings
```

#### Linux

If nodejs is not already installed....

```bash
apt install nodejs npm
```

Replace HOST with (JebPopOS or JebWSL) depending on the host you are installing
to.

```bash
cd /home/cdunphy/.config/sublime-text-3/Packages/User
ln -s ~/Code/Configs/dotfiles/Sublime/HOST/LSP.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/HOST/Package\ Control.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/HOST/Preferences.sublime-settings
```

#### Common

Starting Sublime should download, install, and configure everything as
required.

### VSCode

#### Mac (Roflania)

```bash
cd /Users/chris/Library/Application Support/Code/User
ln -s ~/Code/Configs/dotfiles/VSCode/Roflania/settings.json
cd ~/Code/Configs/dotfiles/VSCode/Roflania
./install-exts.sh
```

#### Linux

Replace HOST with (JebPopOS or JebWSL) depending on the host you are installing
to.

```bash
cd /home/cdunphy/.config/Code/User
ln -s ~/Code/Configs/dotfiles/VSCode/HOST/settings.json
cd ~/Code/Configs/dotfiles/VSCode/HOST
./install-exts.sh
```

### XMonad and XMobar

XMonad is a great tiling Window Manager to use with Linux VM's as it is very lightweight and
also is extremely productive once setup.  First install xmonad, xmobar, and xmonad-contrib
.  I also recommend you install lightdm (with lightdm-gtk-greeter) so that you can login to
XMonad that way.

```bash
ln -s ~/Code/Configs/dotfiles/XMonadConfig/src/ ~/.xmonad
ln -s ~/Code/Configs/dotfiles/XMobar ~/.config/xmobar
cd ~/.xmonad
xmonad --recompile
```
