{ pkgs, ... }:
{
  imports = [
    ../../hm_base.nix
    ../../agent-skills.nix
    ../../opencode.nix
    ../../dev-agents.nix
    ../../rift.nix
    ../../rex.nix
  ];

  programs.opencode.settings = builtins.fromJSON (builtins.readFile ../../../static/hosts/Schooner/opencode-superlogical.json);

  home = {
    packages = with pkgs; [
      docker-compose
      gh
      mkcert
      nss.tools
      skills
      skopeo
    ];

    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/config".source = ../../../static/hosts/Schooner/ssh_config;
    file.".ssh/allowed_signers".source = ../../../static/certs/rcd_pub_key;
  };
}
