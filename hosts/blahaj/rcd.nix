{ pkgs, ... }:
{
  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    fish = import ../../nix/fish.nix { inherit pkgs; };
    zellij = import ../../nix/zellij.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    bat = import ../../nix/bat.nix;
    fzf = import ../../nix/fzf.nix;
    zoxide = import ../../nix/zoxide.nix;
    nh = import ../../nix/nh.nix;
    git = import ../../nix/git.nix;
    direnv = import ../../nix/direnv.nix;
  };

  catppuccin = {
    enable = true;
    flavor = "latte";
    accent = "sky";
  };

  xdg.configFile = {
    nvim = {
      source = ../../config/nvim;
      target = "nvim";
    };
    zellij = {
      source = ../../config/zellij;
      target = "zellij";
    };
  };
}
