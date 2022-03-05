#     ___   __                  _      __  ___                 _   __              __
#    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
#   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
#  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
# /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
#                                              /____/
# fish shell config

# Environment Variables
#######################

set -gx EDITOR nvim
set -gx NPM_PACKAGES $HOME/.npm-packages
set -gx NODE_PATH "$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# Ask Firefox to use Wayland
set -gx MOZ_ENABLE_WAYLAND 1

# Make Alacritty use XWayland
set -gx WINIT_UNIX_BACKEND x11

## PyEnv
########

status is-login; and pyenv init --path | source
pyenv init --path | source

## Aliases
##########

# I just love NeoVim
alias vi="nvim"
alias vim="nvim"

# Fun web services
alias wx="curl wttr.in/Calgary"
alias moon="curl wttr.in/moon"

# dust is a Rust replacement for du
alias du="dust"

# exa is a Rust based replacement for ls
alias ls="exa"
alias ll="exa -lah"

# Directory aliases
alias ch="cd ~"
alias cr="cd ~/Code/Rust/"
alias cg="cd ~/Code/Go/"
alias cpy="cd ~/Code/Python/"
alias ce="cd ~/Code/Exercism/"
alias cgo="cd ~/Code/Go/"
alias cdot="cd ~/Code/Configs/dotfiles/" 

alias df="duf"

alias cat="bat --paging=never --style=plain"
alias go "grc go"

# Just use ripgrep
alias grep="rg"

# Convenient shortcuts
alias vconf="nvim $HOME/.config/nvim/init.lua"
alias fconf="nvim $HOME/.config/fish/config.fish"

