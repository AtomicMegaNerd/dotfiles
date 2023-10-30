{ config, pkgs, ... }:
{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    starship
  ];

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.helix = import ../../common/helix.nix { inherit pkgs; };

  programs.fish =
    {
      enable = true;

      shellInit = ''
        set -gx NIX_PATH $NIX_PATH:$HOME/.nix-defexpr/channels
      '';

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        # name: 'Catppuccin frappe'
        # url: 'https://github.com/catppuccin/fish'
        # preferred_background: 303446

        set -g fish_color_normal c6d0f5
        set -g fish_color_command 8caaee
        set -g fish_color_param eebebe
        set -g fish_color_keyword e78284
        set -g fish_color_quote a6d189
        set -g fish_color_redirection f4b8e4
        set -g fish_color_end ef9f76
        set -g fish_color_comment 838ba7
        set -g fish_color_error e78284
        set -g fish_color_gray 737994
        set -g fish_color_selection --background=414559
        set -g fish_color_search_match --background=414559
        set -g fish_color_option a6d189
        set -g fish_color_operator f4b8e4
        set -g fish_color_escape ea999c
        set -g fish_color_autosuggestion 737994
        set -g fish_color_cancel e78284
        set -g fish_color_cwd e5c890
        set -g fish_color_user 81c8be
        set -g fish_color_host 8caaee
        set -g fish_color_host_remote a6d189
        set -g fish_color_status e78284
        set -g fish_pager_color_progress 737994
        set -g fish_pager_color_prefix f4b8e4
        set -g fish_pager_color_completion c6d0f5
        set -g fish_pager_color_description 737994

        starship init fish | source
      '';

      shellAliases = {
        ls = "eza";
        ll = "eza -lah";
        df = "duf";
        cat = "bat --paging=never --style=plain";

        # Just use ripgrep
        grep = "rg";

        tl = "tmux list-sessions";
        ta = "tmux attach";
        tk = "tmux kill-session";
        tka = "tmux kill-server";
      };

      functions =
        {
          tn = "tmux new -s (basename (eval pwd))";
        };

      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];
    };


  programs.tmux = {
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

      set -g @catppuccin_flavour 'frappe'
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };
}
