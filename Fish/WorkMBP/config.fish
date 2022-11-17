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

# Not Inspec? ;-)
alias inspec="cinc-auditor"

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

# Tell Colima where to get the certs
set -gx CERTS $HOME/Certs/
set -gx DOCKER_HOST "unix://$HOME/.colima/default/docker.sock"

# PATH
# ===================================
fish_add_path $HOME/bin 
fish_add_path $HOME/.fzf/bin
fish_add_path "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.pyenv.bin

# Ruby and Inspec
fish_add_path -p /usr/local/opt/ruby/bin/
fish_add_path /usr/local/lib/ruby/gems/3.1.0/bin

# OMF Bobthefish theme options
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -g theme_nerd_fonts yes
set -g theme_color_scheme nord
set -g theme_newline_cursor yes
set -g theme_newline_prompt '% '
