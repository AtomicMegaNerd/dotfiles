{ config, pkgs, ... }:
{
  home.username = "rcd";
  home.homeDirectory = "/home/rcd";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neofetch
    starship
    eza
    du-dust
    fish
    htop
    glow
    tldr
    wget
    curl
    duf
    ripgrep
    fd
    grc
    zip
    unzip
    procs
    jq
  ];

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.tmux = import ../../common/tmux.nix { inherit pkgs; };
  programs.starship = import ../../common/starship.nix { inherit pkgs; };
  programs.fish = import ../../common/fish.nix { inherit pkgs; };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };
}
