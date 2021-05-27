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

This is based on my [GitHub dotfiles repp](https://github.com/AtomicMegaNerd/dotfiles) but 
with additional configs for work that are kept only in CTC BitBucket.  This lets me pull in
enhancements I make from my personal configs but also to have some work specific settings.

As such I usually have two remotes on this repo at work:

- github - I pull from the GitHub remote to pull in changes from my personal configs.
- origin - I then push the changes along with work specific configs to BitBucket.

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

Install the base-16 shell extension for nice colors!  Replace HOST with
the folder that you want (Roflania, JebPopOS, etc).

```bash
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
cd ~/.config
ln -s ~/Code/Configs/dotfiles/HOST/fish
base16-default-dark
```

### NeoVim

If you setup fish the alias from vim to nvim should be setup already. If this
is not the case please set this up first.  I now require the 0.5 branch.

#### Mac

```bash
brew install neovim --HEAD
brew install node
pip install --user neovim
npm install -g tree-sitter-cli neovim
```

#### Linux

Download the latest 0.5 binary release from [here](https://github.com/neovim/neovim)
and put it in folder.  Add the bin directory to the PATH.

```bash
mkdir ~/Apps
cp nvim-linux64.tar.gz ~/Apps
cd ~/Apps
tar -zxvf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
set -Ux fish_user_paths ~/Apps/nvim-linux64/bin/ $fish_user_paths
apt install nodejs npm
pip intall --user neovim
npm install -g tree-sitter-cli neovim
```

#### Common

After doing the Mac or Linux parts next install vim-plug:

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

To configure:

```bash
mkdir ~/.config/nvim
cd ~/.config/nvim
ln -s ~/Code/Configs/dotfiles/NeoVim/init.vim
ln -s ~/Code/Configs/dotfiles/NeoVim/coc-settings.json
vim +PLugInstall +UpdateRemotePlugins
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
