set -gx EDITOR nvim

pyenv init - | source

## Aliases

alias vim="nvim"
#alias ls="exa"
#alias ll="exa -lah"
alias wx="curl wttr.in/Calgary"
alias moon="curl wttr.in/moon"

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

