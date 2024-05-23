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
    starship = import ../../common/starship.nix { inherit pkgs; };
    fish = import ../../common/fish.nix { inherit pkgs; };
    zellij = import ../../common/zellij.nix { inherit pkgs; };
    tmux = import ../../common/tmux.nix { inherit pkgs; };
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
      waybar = {
        source = ../../common/waybar;
        target = "waybar";
      };
      alacritty = {
        source = ../../common/alacritty;
        target = "alacritty";
      };
    };
  };

  # Dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };
  gtk.enable = true;
  gtk.theme.name = "Adwaita-dark";
}
