#     ___   __                  _      __  ___                 _   __              __
#    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
#   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
#  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
# /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
#                                              /____/
# fish shell config

set -gx EDITOR nvim
set -gx NPM_PACKAGES $HOME/.npm-packages
set -gx NODE_PATH "$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

pyenv init - | source

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

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

# fish-ssh-agent
if test -z "$SSH_ENV"
    set -xg SSH_ENV $HOME/.ssh/environment
end
if not __ssh_agent_is_started
    __ssh_agent_start
end
