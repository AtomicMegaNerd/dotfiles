{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "24.05";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    fish = import ../../nix/fish.nix { inherit pkgs; };
    tmux = import ../../nix/tmux.nix;
    starship = import ../../nix/starship.nix;
    alacritty = import ../../nix/alacritty.nix;
    zellij = import ../../nix/zellij.nix;
    bat = import ../../nix/bat.nix;

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
      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
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

  xdg.configFile = {
    nvim = {
      source = ../../config/nvim;
      target = "nvim";
    };
  };
}
