{ pkgs, ... }:
{
  imports = [ ../../nix/hm_base.nix ];

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/hm_packages.nix { inherit pkgs; };
  };
}
