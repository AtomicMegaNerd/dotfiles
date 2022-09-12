# Aliases
# ===================================
alias ls "exa"
alias du "dust"
alias grep "rg"
alias wx "curl wttr.in/Calgary"
alias moon "curl wttr.in/moon"
alias vim "nvim"
alias vi "nvim"
alias cat "bat --paging=never --style=plain"
alias df "duf"

# Shortcuts for common files and directories
alias vconf "nvim ~/.config/nvim/init.lua"
alias fconf "nvim ~/.config/fish/config.fish"
alias cconf "nvim ~/.config/fish/conf.d/credentials.fish"
alias ch="cd ~"
alias csrc="cd ~/Code"
alias cgo="cd ~/Code/Go"
alias cj="cd ~/Code/Java"
alias cpy="cd ~/Code/Python"
alias cdot="cd ~/Code/Configs/dotfiles"
alias cdock="cd ~/Code/Docker"
alias update_creds="$EDITOR ~/.config/fish/conf.d/credentials.fish"

# Colorize go
alias go "grc go"

# Shorten Terraform
alias tf terraform

# EDITOR
# ===================================
set -gx EDITOR nvim

# General flags
# ===================================
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1

# Tell NodeJS about our internal CTC certs
# set -gx NODE_EXTRA_CA_CERTS /Users/chris.dunphy/Certs/CTC_CA_bundle.crt

# Tell Vault to use JSON output
set -gx VAULT_FORMAT json

# Python
# ===================================
# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:
status is-interactive; and pyenv init --path | source
pyenv init - | source

# Go
set -gx GOPRIVATE dev.azure.com

# iTerm 2
# ===================================
test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Java and Friends
# ===================================
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home
set -gx GROOVY_HOME /usr/local/opt/groovy/libexec
set -gx GRADLE_USER_HOME $HOME/.gradle

# PATH
# ===================================
set -gx fish_user_paths $HOME/bin $fish_user_paths
set -gx fish_user_paths $HOME/.fzf/bin $fish_user_paths
set -gx fish_user_paths $HOME/.gem/ruby/2.6.0/bin $fish_user_paths
set -gx fish_user_paths "/Applications/Sublime Text.app/Contents/SharedSupport/bin" $fish_user_paths

# Theme options
set -g theme_nerd_fonts yes
set -g theme_color_scheme nord

