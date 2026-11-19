{ ... }:
{

  imports = [
    ../../hm_base.nix
  ];

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
  };

  # See: https://www.superlogical.com/rex/docs/linux/installation#the-home-manager-module
  services.rex.enable = true;
}
