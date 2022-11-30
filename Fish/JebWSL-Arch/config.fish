#     ___   __                  _      __  ___                 _   __              __
#    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
#   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
#  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
# /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
#                                              /____/
# fish shell config

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.yarn/bin

# Environment Variables
#######################

set -gx EDITOR nvim
set -gx NPM_PACKAGES $HOME/.npm-packages
set -gx NODE_PATH "$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

## Aliases
##########

# I just love NeoVim
alias vi="nvim"
alias vim="nvim"

# dust is a Rust replacement for du
alias du="dust"

# exa is a Rust based replacement for ls
alias ls="exa"
alias ll="exa -lah"

# duf is a replacement for df
alias df="duf"

# bat is a modern replacement for cat
alias cat="bat --paging=never --style=plain"

# Directory aliases
alias ch="cd ~"
alias csrc="cd ~/Code"
alias cr="cd ~/Code/Rust/"
alias cg="cd ~/Code/Go/"
alias cpy="cd ~/Code/Python/"
alias ce="cd ~/Code/Exercism/"
alias cgo="cd ~/Code/Go/"
alias cdot="cd ~/Code/Configs/dotfiles/" 

# Colorize
alias go "grc go"
alias ip "grc ip"

# Just use ripgrep
alias grep="rg"

# Helix
alias hx="helix"

# Convenient shortcuts
alias vconf="nvim $HOME/.config/nvim/init.lua"
alias fconf="nvim $HOME/.config/fish/config.fish"
alias aconf="nvim $HOME/.config/alacritty/alacritty.yml"
