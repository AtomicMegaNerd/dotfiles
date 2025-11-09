{ pkgs, ... }:
{
  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = import ../../nix/hm_common.nix { inherit pkgs; } // {
    # This allows Zed to use its remote server feature to connect to this machine
    zed-editor.installRemoteServer = true;
  };

  catppuccin = import ../../nix/catppuccin.nix;
  xdg.configFile = import ../../nix/xdg.nix;
}
