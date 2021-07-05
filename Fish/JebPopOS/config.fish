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

# Just use ripgrep
alias grep="rg"

# Convenient shortcuts
alias vconf="nvim $HOME/.config/nvim/init.vim"
alias fconf="nvim $HOME/.config/fish/config.fish"

## Shell Theme
##############

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

# Set the shell theme
base16-default-dark
