{ pkgs, ... }:
{
  imports = [
    ../../nix/hm_base.nix
    ../../nix/claude-code.nix
    ../../nix/ghostty.nix
    ../../nix/opencode.nix
    ../../nix/rift.nix
  ];

  home = {
    packages = with pkgs; [
      docker-compose
      gh
      skills
    ];

    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/config".source = ../../static/Schooner/ssh_config;
    file.".ssh/allowed_signers".source = ../../static/rcd_pub_key;
  };
}
