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

    # Starship prompt
    # ===================================
    starship init fish | source

    # Zoxide
    # ===================================
    zoxide init fish --cmd cd | source

    # Fzf
    # ===================================
    fzf --fish | source

    # Direnv
    # ===================================
    direnv hook fish | source
end

# Go
# ===================================
# This lets us use Go modules hosted on Azure DevOps
set -gx GOPRIVATE dev.azure.com
# This is a workaround for the issue with Go modules behind our corporate proxy
set -gx GOPROXY direct

# CLI THEME
# ===================================
set -gx CLI_THEME "catppuccin"

# Neovim
# ===================================
set -gx EDITOR nvim
set -gx NVIM_LOG_FILE ~/.local/share/nvim/nvim.log

# Other Variables
# ===================================
set fish_greeting # Disable greeting
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx CERTS $HOME/Certs/

# PATH
# ===================================
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path /opt/homebrew/bin

