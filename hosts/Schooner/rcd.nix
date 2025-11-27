{ pkgs, ... }:
let
  rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in
{
  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/allowed_signers".text = "${rcd_pub_key}";
    file.".ssh/config".text = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

      Host 192.168.1.*
          ForwardAgent yes

      Host blahaj
          ForwardAgent yes
    '';
    shell.enableShellIntegration = true;
    packages = import ../../nix/packages.nix { inherit pkgs; } ++ [
      pkgs.monaspace
      pkgs.jetbrains-mono
      pkgs.nerd-fonts.monaspace
      pkgs.nerd-fonts.jetbrains-mono
    ];
  };

  programs = (import ../../nix/hm_common.nix { inherit pkgs; }) // {
    ghostty = import ../../nix/ghostty.nix { inherit pkgs; };
  };
  catppuccin = import ../../nix/catppuccin.nix;
  xdg.configFile = import ../../nix/xdg.nix;
}
