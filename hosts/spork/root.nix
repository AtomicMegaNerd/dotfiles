{ config, pkgs, ... }:
{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    oh-my-posh
    grc
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

        ### Nightfox theme ###
        set -l foreground cdcecf
        set -l selection 223249
        set -l comment 526176
        set -l red c94f6d
        set -l orange f4a261
        set -l yellow dbc074
        set -l green 81b29a
        set -l purple 9d79d6
        set -l cyan 63cdcf
        set -l pink d67ad2

        # Syntax Highlighting Colors
        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_math --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment

        # Completion Pager Colors
        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $commentc

        oh-my-posh init fish --config ~/.config/oh-my-posh/rcd.omp.json | source
      '';

      shellAliases = {
        ls = "exa";
        ll = "exa -lah";
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
    tmux = {
      source = ../../common/tmux;
      target = "tmux";
    };
    oh-my-posh = {
      source = ../../common/oh-my-posh;
      target = "oh-my-posh";
    };
  };
}
