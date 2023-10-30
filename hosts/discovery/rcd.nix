{ config, pkgs, ... }:
let
  rcd_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul";
in
{
  home.username = "rcd";
  home.homeDirectory = "/Users/rcd";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neofetch
    eza
    duf
    du-dust
    grc
    ripgrep
    fd
    glow
    tldr
    lazygit
    ncurses
    starship
    fish
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
      set -gx EDITOR nvim
      set -gx GOPATH $HOME/.local/go
      set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

      # Fixes color bug on MacOS
      set -gx TERMINFO_DIRS $TERMINFO_DIRS:$HOME/.local/share/terminfo

      # Enable Homebrew for casks
      fish_add_path /opt/homebrew/bin
      fish_add_path /opt/homebrew/sbin
      fish_add_path ~/.nix-profile/bin 
      fish_add_path /nix/var/nix/profiles/default/bin
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
  };

  home.file.".ssh/allowed_signers".text = "${rcd_pub_key}";
  programs.git = {
    enable = true;
    userName = "Chris Dunphy";
    userEmail = "chris@megaparsec.ca";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      gpg.format = "ssh";
      gpg.ssh = {
        allowedSignersFile = "/Users/rcd/.ssh/allowed_signers";
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      user.signingkey = "${rcd_pub_key}";
      commit.gpgsign = true;
      push.autoSetupRemote = true;
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

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Medium";
        };
        size = 16;
      };
      env = {
        TERM = "xterm-256color";
      };
      cursor = {
        style = {
          shape = "Block";
          blinking = "Always";
        };
      };
      mouse_bindings = [
        { mouse = "Right"; action = "Paste"; }
        { mouse = "Left"; action = "Copy"; }
      ];
      window = {
        startup_mode = "Fullscreen";
        padding = {
          x = 3;
          y = 3;
        };
        opacity = 0.97;
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
}
