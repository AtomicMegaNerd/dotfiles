{ pkgs, ... }: {
  home.username = "rcd";
  home.homeDirectory = "/home/rcd";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neofetch
    glow
    tldr
    wget
    curl
    du-dust
    duf
    htop
    ripgrep
    fd
    eza
    grc
    zip
    unzip
    procs
    jq
    fish
    dos2unix
    zoxide
  ];

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.starship = import ../../common/starship.nix { inherit pkgs; };
  programs.fish = import ../../common/fish.nix { inherit pkgs; };
  programs.zellij = import ../../common/zellij.nix { inherit pkgs; };
  programs.tmux = import ../../common/tmux.nix { inherit pkgs; };
  programs.helix = import ../../common/helix.nix { inherit pkgs; };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Chris Dunphy";
    userEmail = "chris@megaparsec.ca";
    extraConfig = {
      core.sshCommand = "ssh.exe";
      init.defaultBranch = "main";
      pull.rebase = false;
      user.signingkey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul";
      gpg = {
        ssh = {
          program = "/mnt/c/Program Files/1Password/app/8/op-ssh-sign.exe";
        };
        format = "ssh";
      };
      commit = { gpgsign = true; };
    };
  };

  programs.bat = {
    enable = true;
    config = { theme = "Nord"; };
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

