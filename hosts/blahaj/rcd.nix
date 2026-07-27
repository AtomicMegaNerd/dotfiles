{ ... }:
{
  # This is a headless server
  amnOptions.hasGui = false;

  imports = [
    ../../nix/hm_base.nix
  ];

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
  };
}
