# Environment
# =============================================================================
set fish_greeting # Disable greeting

# XDG
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CONFIG_HOME $HOME/.config

# Telemetry
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

# Internal CA Certs
set -gx CERTS $HOME/Certs/
set -gx NODE_EXTRA_CERTS $CERTS/ctc-combined.pem

# Apps
set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
set -gx EDITOR nvim
set -gx NVIM_LOG_FILE $XDG_DATA_HOME/nvim.log
set -gx COLOR_THEME "catppuccin"
set -gx HERDR_APP_HOME $XDG_CONFIG_HOME/herdr-app

# Man Pager
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"

# Path
# =============================================================================
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $HOME/.local/bin

# Theme
# =============================================================================
fish_config theme choose catppuccin-frappe

if status is-interactive
    # Aliases
    # =============================================================================
    alias ls "eza"
    alias du "dust"
    alias grep "rg"
    alias vim "nvim"
    alias vi "nvim"
    alias cat "bat --paging=never --style=plain"
    alias df "duf"
    alias cas "cd ~/Library/Application\ Support/"

    # Terraform
    alias tf terraform

    # Podman
    alias docker podman

    # Lazygit
    alias lg "lazygit"

    # Initialize CLI Apps
    # =============================================================================
    # Starship
    starship init fish | source
    # Zoxide
    zoxide init fish --cmd cd | source
    # Mise
    mise activate fish | source
end
