{ config, pkgs, ... }:
let
  rcd_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul";
in
{
  home.username = "rcd";
  home.homeDirectory = "/Users/rcd";
  home.stateVersion = "23.11";
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
    nmap
  ];

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.tmux = import ../../common/tmux.nix { inherit pkgs; };
  programs.starship = import ../../common/starship.nix { inherit pkgs; };
  programs.zellij = import ../../common/zellij.nix { inherit pkgs; };

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

      # Zellij
      zl = "zellij ls";
      za = "zellij a";
      zk = "zellij k";
      zka = "zellij ka";
    };

    functions =
      {
        tn = "tmux new -s (basename (eval pwd))";
        zn = "zellij -s (basename (eval pwd))";
      };

    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };

  xdg.configFile = {
    alacritty = {
      source = ../../non-nix/Alacritty/Discovery;
      target = "alacritty";
    };
  };
}
