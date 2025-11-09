{ pkgs, ... }:
{
  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = import ../../nix/hm_common.nix { inherit pkgs; };
  catppuccin = import ../../nix/catppuccin.nix;
  xdg.configFile = import ../../nix/xdg.nix;
}
