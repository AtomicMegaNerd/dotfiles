#     ___   __                  _      __  ___                 _   __              __
#    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
#   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
#  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
# /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
#                                              /____/
# fish shell config

# Add my SSH key from the Keychain
ssh-add --apple-use-keychain ~/.ssh/id_rsa

# Default editor
set -gx EDITOR nvim

## Aliases

# I just love NeoVim
alias vi "nvim"
alias vim "nvim"

# dust is a Rust replacement for du
alias du "dust"

# exa is a Rust based replacement for ls
alias ls "exa"
alias ll "exa -lah"

# duf is a replacement for df
alias df "duf"

# Use bat instead of cat
alias cat "bat --paging=never --style=plain"

# Aliases for local files and directories
alias vconf "nvim ~/.config/nvim/init.lua"
alias fconf "nvim ~/.config/fish/config.fish"
alias ch="cd ~"
alias cr="cd ~/Code/Rust/"
alias cg="cd ~/Code/Go/"
alias cpy="cd ~/Code/Python/"
alias ce="cd ~/Code/Exercism/"
alias cdot="cd ~/Code/Configs/dotfiles/" 

alias go "grc go"
alias ifconfig "grc ifconfig"
alias ip "grc ip"

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:
status is-login; and pyenv init --path | source

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

