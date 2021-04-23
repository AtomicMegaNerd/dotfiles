set -gx EDITOR nvim

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

# fish-ssh-agent is used on the Mac but not on my Linux OS
switch (uname)
case Darwin
    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end
    if not __ssh_agent_is_started
        __ssh_agent_start
    end
end
