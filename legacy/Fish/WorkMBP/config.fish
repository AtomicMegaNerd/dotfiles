# Aliases
# ===================================
alias ls "eza"
alias du "dust"
alias grep "rg"
alias vim "nvim"
alias vi "nvim"
alias cat "bat --paging=never --style=plain"
alias df "duf"

# Common directories
alias ch="cd ~"
alias csrc="cd ~/Code"
alias cgo="cd ~/Code/Go"
alias cj="cd ~/Code/Java"
alias cpy="cd ~/Code/Python"
alias cdot="cd ~/Code/Configs/dotfiles"
alias cdock="cd ~/Code/Docker"

# Shortcuts for common files and directories
alias vconf "nvim ~/.config/nvim/init.lua"
alias fconf "nvim ~/.config/fish/config.fish"
alias cconf "nvim ~/.config/fish/conf.d/credentials.fish"
alias aconf "nvim ~/.config/alacritty/alacritty.yml"

# Terraform
alias tf terraform

# tmux
alias tl "tmux list-sessions"
alias ta "tmux attach"
alias tk "tmux kill-session"
alias tka "tmux kill-server"

# Zellij
alias zl "zellij ls"
alias za "zellij a"
alias zk "zellij k"
alias zka "zellij ka"
alias zda "zellij da"

# Functions
# ===================================

function tn
    tmux new -s (basename (eval pwd))
end

function zn
    zellij -s (basename (eval pwd))
end

# Variables
# ===================================
set fish_greeting # Disable greeting
set -gx EDITOR nvim
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# Used by the dotfiles. For example my neovim config behaves differently if it is configured
# by Nix.
set -gx AMN_INSTALL_TYPE "non-nix"

# Fixes an issue with MacOS' super out of date terminfo
set -gx TERMINFO_DIRS "$TERMINFO_DIRS:$HOME/.local/share/terminfo"

# Go
set -gx GOPRIVATE dev.azure.com

# Tell Vault to use JSON output
set -gx VAULT_FORMAT json

# Tell Colima where to get the certs
set -gx CERTS $HOME/Certs/

# PATH
# ===================================
fish_add_path $HOME/bin 
fish_add_path $HOME/.fzf/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.pyenv/bin

# Pyenv
# ===================================
status is-interactive; and pyenv init --path | source
pyenv init - | source

# Starship prompt
# ===================================
starship init fish | source

# Zoxide
# ===================================
zoxide init fish | source
