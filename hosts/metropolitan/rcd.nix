{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "24.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    fish = import ../../nix/fish.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    zellij = import ../../nix/zellij.nix;
    bat = import ../../nix/bat.nix;
    zed-editor = import ../../nix/zed.nix;

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
        credential = {
          helper = "manager";
          "https://github.com".username = "AtomicMegaNerd";
          credentialStore = "cache";
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = { enable = true; };

  };

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  xdg.configFile = {
    nvim = {
      source = ../../config/nvim;
      target = "nvim";
    };
    zellij = {
      source = ../../config/zellij/linux;
      target = "zellij";
    };
    ghostty = {
      source = ../../config/ghostty;
      target = "ghostty";
    };
  };
}
