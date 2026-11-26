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

  services.rex.enable = true;
}
