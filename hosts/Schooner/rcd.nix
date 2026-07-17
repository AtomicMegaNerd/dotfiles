{ ... }:
{
  imports = [
    ../../nix/hm_base.nix
    ../../nix/ghostty.nix
    ../../nix/opencode.nix
  ];

  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/config".source = ../../static/Schooner/ssh_config;
    file.".ssh/allowed_signers".source = ../../static/rcd_pub_key;
  };
}
