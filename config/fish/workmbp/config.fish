if status is-interactive
    # Aliases
    # ===================================
    alias ls "eza"
    alias du "dust"
    alias grep "rg"
    alias vim "nvim"
    alias vi "nvim"
    alias cat "bat --paging=never --style=plain"
    alias df "duf"

    # Shortcuts for common files and directories
    alias vconf "nvim ~/.config/nvim/init.lua"
    alias fconf "nvim ~/.config/fish/config.fish"
    alias cconf "nvim ~/.config/fish/conf.d/credentials.fish"
    alias aconf "nvim ~/.config/alacritty/alacritty.yml"

    # Terraform
    alias tf terraform

    # Podman
    alias docker podman

    # Zellij
    alias zl "zellij ls"
    alias za "zellij a"
    alias zk "zellij k"
    alias zka "zellij ka"
    alias zda "zellij da"

    # Functions
    function zn
        zellij -s (basename (eval pwd))
    end
end

# Variables
# ===================================
set fish_greeting # Disable greeting
set -gx EDITOR nvim
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# CLI Theme
# ===================================

set -gx CLI_THEME catppuccin

# Fixes an issue with MacOS' super out of date terminfo
set -gx TERMINFO_DIRS "$TERMINFO_DIRS:$HOME/.local/share/terminfo"

# Go
set -gx GOPRIVATE dev.azure.com

# Tell Vault to use JSON output
set -gx VAULT_FORMAT json

set -gx CERTS $HOME/Certs/

# Deal with corporate proxies
set -gx NODE_TLS_REJECT_UNAUTHORIZED 0

# Logging for Neovim
set -gx NVIM_LOG_FILE ~/.local/share/nvim/nvim.log

# PATH
# ===================================
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.pyenv/bin
fish_add_path $HOME/go/bin

# Pyenv
# ===================================
status is-interactive; and pyenv init --path | source
pyenv init - | source

# Starship prompt
# ===================================
status is-interactive; and starship init fish | source

# Zoxide
# ===================================
status is-interactive; and zoxide init fish --cmd cd | source

# Fzf
# ===================================
status is-interactive; and fzf --fish | source

# Atuin
# ===================================
status is-interactive; and atuin init fish | source
