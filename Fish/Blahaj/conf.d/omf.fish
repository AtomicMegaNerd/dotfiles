# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

# Tell omg themes we have the nerd fonts installed
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -g theme_nerd_fonts yes
set -g theme_color_scheme terminal-dark
set -g theme_newline_cursor yes
set -g theme_newline_prompt '% '
