{ pkgs, ... }: {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../common/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    fish = import ../../common/fish.nix { inherit pkgs; };
    neovim = import ../../common/neovim.nix { inherit pkgs; };
    starship = import ../../common/starship.nix;
    zellij = import ../../common/zellij.nix;
    tmux = import ../../common/tmux.nix;
    alacritty = import ../../common/alacritty.nix;
    bat = import ../../common/bat.nix;
    waybar = import ../../common/waybar.nix;

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

    ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        Host *
                IdentityAgent ~/.1password/agent.sock
      '';
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      associations.added = { "text/html" = "firefox.desktop"; };
      defaultApplications = { "text/html" = "firefox.desktop"; };
    };

    configFile = {
      nvim = {
        source = ../../common/nvim;
        target = "nvim";
      };
      hypr = {
        source = ../../common/hypr;
        target = "hypr";
      };
    };
  };
}
