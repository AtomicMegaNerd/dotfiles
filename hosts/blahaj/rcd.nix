{ pkgs, ... }:
{
  imports = [ ../../nix/hm_base.nix ];

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };
}
