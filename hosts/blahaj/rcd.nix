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
    fish = import ../../common/fish.nix { inherit pkgs; };
    tmux = import ../../common/tmux.nix;
    starship = import ../../common/starship.nix;
    zellij = import ../../common/zellij.nix;
    bat = import ../../common/bat.nix;

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
