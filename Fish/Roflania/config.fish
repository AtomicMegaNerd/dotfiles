#     ___   __                  _      __  ___                 _   __              __
#    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
#   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
#  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
# /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
#                                              /____/
# fish shell config

# Add my SSH key from the Keychain
ssh-add -K ~/.ssh/id_rsa

# Default editor
set -gx EDITOR nvim

## Aliases

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

# Aliases for confiuguration files
alias vconf="nvim ~/.config/nvim/init.vim"
alias fconf="nvim ~/.config/fish/config.fish"

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:
status is-login; and pyenv init --path | source

# Enable iTerm2 shell integration
source ~/.iterm2_shell_integration.(basename $SHELL)

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

base16-default-dark
