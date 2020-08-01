# AtomicMegaNerd's Linux/MacOS Configs

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

```bash
cd ~/.config
ln -s ~/Code/Configs/dotfiles/fish
```

### NeoVim

If you setup fish the alias from vim to nvim should be setup already. If this
is not the case please set this up first.

#### Mac

```bash
brew install neovim node
pip install --user neovim
```

#### Linux

```bash
apt install neovim nodejs npm
pip intall --user neovim
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

#### Mac

If nodejs is not already installed....

```bash
brew install node
```

```bash
cd /Users/chris/Library/Application Support/Sublime Text 3/Packages/User
ln -s ~/Code/Configs/dotfiles/Sublime/LSP.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/Package\ Control.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/Preferences.sublime-settings
```

#### Linux

If nodejs is not already installed....

```bash
apt install nodejs npm
```

```bash
cd /home/cdunphy/.config/sublime-text-3/Packages/User
ln -s ~/Code/Configs/dotfiles/Sublime/LSP.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/Package\ Control.sublime-settings
ln -s ~/Code/Configs/dotfiles/Sublime/Preferences.sublime-settings
```

#### Common

Starting Sublime should download, install, and configure everything as
required.

### VSCode

#### Mac

```bash
cd /Users/chris/Library/Application Support/Code/User
ln -s ~/Code/Configs/dotfiles/VSCode/settings.json
cd ~/Code/Configs/dotfiles/VSCode
./install-exts.sh
```

#### Linux

```bash
cd /home/cdunphy/.config/Code/User
ln -s ~/Code/Configs/dotfiles/VSCode/settings.json
cd ~/Code/Configs/dotfiles/VSCode
./install-exts.sh
```
