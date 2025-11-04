{ pkgs, ... }:
{
  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = import ../../nix/hm_common.nix { inherit pkgs; };

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
