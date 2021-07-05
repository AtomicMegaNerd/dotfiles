# Aliases
# ===================================
alias ls "exa"
alias du "dust"
alias grep "rg"
alias wx "curl wttr.in/Calgary"
alias moon "curl wttr.in/moon"
alias vim "nvim"
alias vi "nvim"
alias k "kubectl"
alias d "docker"
alias t "terraform"
alias g "git"

# EDITOR
# ===================================
set -gx EDITOR nvim

# General flags
# ===================================
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1

# Python
# ===================================
# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:
status is-login; and pyenv init --path | source

# iTerm 2
# ===================================
test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Java and Friends
# ===================================
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
set -gx GROOVY_HOME /usr/local/opt/groovy/libexec

# PATH
# ===================================
set -gx fish_user_paths $HOME/bin $fish_user_paths
set -gx fish_user_paths $HOME/.fzf/bin $fish_user_paths

# Base16 Shell - For nice colors
# ===================================
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

# Gruvbox
base16-default-dark
