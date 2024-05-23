{ pkgs, ... }: {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../common/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../common/neovim.nix { inherit pkgs; };
    tmux = import ../../common/tmux.nix { inherit pkgs; };
    starship = import ../../common/starship.nix { inherit pkgs; };
    fish = import ../../common/fish.nix { inherit pkgs; };
    zellij = import ../../common/zellij.nix { inherit pkgs; };
    bat = import ../../common/bat.nix { inherit pkgs; };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Chris Dunphy";
      userEmail = "chris@megaparsec.ca";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };
}
