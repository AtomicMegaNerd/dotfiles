# Add my SSH key from the Keychain
ssh-add -K ~/.ssh/id_rsa

# Default editor
set -gx EDITOR nvim

# Aliases

## Use exa for ls
alias vi="nvim"
alias vim="nvim"
alias ls="exa"
alias ll="exa -l"
alias wx="curl wttr.in/Calgary"
alias moon="curl wttr.in/moon"

# Start PyEnv
status --is-interactive; and source (pyenv init -|psub)

# Enable iTerm2 shell integration
source ~/.iterm2_shell_integration.(basename $SHELL)

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end
