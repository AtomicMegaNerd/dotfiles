{ pkgs, config, ... }:

let
  rcdPubKey = builtins.readFile ../../static/rcd_pub_key;
in
{
  imports = [ ../../nix/hm_base.nix ];

  home = {
    username = "rcd";
    uid = 501;
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/allowed_signers".text = "${rcdPubKey}";
    file.".ssh/config".text = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

      Host 192.168.1.*
          ForwardAgent yes

      Host blahaj
          ForwardAgent yes
    '';
    file.".config/zed".source = config.lib.file.mkOutOfStoreSymlink (
      config.home.homeDirectory + "/Code/Configs/dotfiles/config/zed"
    );
    shell.enableShellIntegration = true;
    packages = import ../../nix/packages.nix { inherit pkgs; } ++ [
      pkgs.monaspace
      pkgs.nerd-fonts.monaspace
      pkgs.podman-compose
      pkgs.github-mcp-server
      pkgs.nodejs
    ];
  };

  programs.ghostty = import ../../nix/ghostty.nix { inherit pkgs; };
  programs.claude-code = import ../../nix/claude.nix;
}
