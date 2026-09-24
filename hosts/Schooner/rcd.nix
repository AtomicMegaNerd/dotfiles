{ pkgs, ... }:
{
  imports = [
    ../../nix/hm_base.nix
    ../../nix/ghostty.nix
    ../../nix/opencode.nix
  ];

  programs.rcd-agent-skills = {
    enable = true;
    agents = [ "opencode" ];
  };

  programs.nix-skills = {
    enable = true;
    agents = [ "opencode" ];
  };

  home = {
    packages = with pkgs; [
      docker-compose
      podman
      gh
    ];

    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/config".source = ../../static/Schooner/ssh_config;
    file.".ssh/allowed_signers".source = ../../static/rcd_pub_key;
  };
}
