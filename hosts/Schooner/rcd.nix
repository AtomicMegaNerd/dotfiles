{ pkgs, lib, ... }:
{
  imports = [
    ../../nix/hm_base.nix
    ../../nix/zed.nix
  ];

  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/config".text = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

      Host 192.168.1.*
          ForwardAgent yes

      Host blahaj
          ForwardAgent yes
    '';
    packages = import ../../nix/hm_packages.nix { inherit pkgs; } ++ [
      pkgs.docker-compose
      pkgs.podman
      pkgs.gh
    ];
  };

  programs = {
    ghostty = import ../../nix/ghostty.nix;
    opencode = import ../../nix/opencode.nix { inherit lib; };
  };
}
