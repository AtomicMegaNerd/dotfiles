set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $HOME/.pyenv/bin
status is-login; and pyenv init --path | source
