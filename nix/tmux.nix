{
  enable = true;
  prefix = "C-a";
  extraConfig = ''
    set -g default-terminal "tmux-256color"
    set-option -sa terminal-overrides ",xterm-256color:RGB"
    set-option -sg escape-time 10
    set-option -g focus-events on
    set-option -g status-position top
    setw -g mouse on
    set -g base-index 1
  '';
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
