{ config, pkgs, ... }:
{
  home.username = "rcd";
  home.homeDirectory = "/home/rcd";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neofetch
    oh-my-posh
    glow
    tldr
    grc
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.helix = import ../../common/helix.nix { inherit pkgs; };

  programs.fish = {
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

      set -x VIRTUAL_ENV_DISABLE_PROMPT 1

      oh-my-posh init fish --config ~/.config/oh-my-posh/rcd.omp.json | source
    '';

    shellAliases = {
      ls = "exa";
      ll = "exa -lah";
      df = "duf";
      cat = "bat --paging=never --style=plain";

      # Directory aliases
      ch = "cd ~";
      csrc = "cd ~/Code";
      cr = "cd ~/Code/Rust/";
      cg = "cd ~/Code/Go/";
      cpy = "cd ~/Code/Python/";
      ce = "cd ~/Code/Exercism/";
      cgo = "cd ~/Code/Go/";
      cdot = "cd ~/Code/Configs/dotfiles";

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
    poetry = {
      source = ../../common/poetry;
      target = "poetry";
    };
    sway = {
      source = ./sway;
      target = "sway";
    };
    waybar = {
      source = ./waybar;
      target = "waybar";
    };
    gtk = {
      source = ./gtk-3.0;
      target = "gtk-3.0";
    };
    yamllint = {
      source = ../../common/yamllint;
      target = "yamllint";
    };
  };

  home.file."/home/rcd/.config/ulauncher".source = config.lib.file.mkOutOfStoreSymlink /home/rcd/Code/Configs/dotfiles/hosts/spork/ulauncher;

  programs.git = {
    enable = true;
    userName = "Chris Dunphy";
    userEmail = "chris@megaparsec.ca";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
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

  fonts.fontconfig.enable = true;

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = ''
      Host *
              IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Medium";
        };
        size = 20;
      };
      cursor = {
        style = {
          shape = "Block";
          blinking = "Always";
        };
      };
      env = {
        TERM = "xterm-256color";
      };
      mouse_bindings = [
        { mouse = "Right"; action = "Paste"; }
        { mouse = "Left"; action = "Copy"; }
      ];
      window = {
        decorations = "none";
        padding = {
          x = 3;
          y = 3;
        };
        opacity = 0.94;
      };
      colors = {
        primary = {
          background = "0x192330";
          foreground = "0xcdcecf";
        };
        normal = {
          black = "0x393b44";
          red = "0xc94f6d";
          green = "0x81b29a";
          yellow = "0xdbc074";
          blue = "0x719cd6";
          magenta = "0x9d79d6";
          cyan = "0x63cdcf";
          white = "0xdfdfe0";
        };
        # Bright colors
        bright = {
          black = "0x575860";
          red = "0xd16983";
          green = "0x8ebaa4";
          yellow = "0xe0c989";
          blue = "0x86abdc";
          magenta = "0xbaa1e2";
          cyan = "0x7ad4d6";
          white = "0xe4e4e5";
        };
        indexed_colors = [
          { index = 16; color = "0xf4a261"; }
          { index = 17; color = "0xd67ad2"; }
        ];
      };
    };
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        After = [ "graphical-session-pre.target" ];
        Description = "polkit-gnome-authentication-agent-1";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        Type = "simple";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  xdg.enable = true;
}
