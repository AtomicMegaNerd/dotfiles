{ pkgs, ... }:
let
  rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in
{
  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/allowed_signers".text = "${rcd_pub_key}";
    file.".ssh/config".source = ../../config/SSH/Schooner/config;
    shell.enableShellIntegration = true;
    packages = import ../../nix/packages.nix { inherit pkgs; } ++ [ ];
  };

  programs = {
    home-manager.enable = true;
    fish = import ../../nix/fish.nix { inherit pkgs; };
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    zellij = import ../../nix/zellij.nix;
    bat = import ../../nix/bat.nix;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

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
      options = [ "--cmd cd" ];
    };

    fzf = {
      enable = true;
    };
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
      source = ../../config/zellij/Schooner;
      target = "zellij";
    };
    ghostty = {
      source = ../../config/ghostty/Schooner;
      target = "ghostty";
    };
    zed = {
      source = ../../config/zed/Schooner;
      target = "zed";
    };
  };
}
