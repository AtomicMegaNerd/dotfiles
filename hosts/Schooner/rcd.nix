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
    file.".ssh/config".source = ../../config/SSH/Schooner/config;
    shell.enableShellIntegration = true;
    packages = import ../../nix/packages.nix { inherit pkgs; } ++ [
      pkgs.monaspace
      pkgs.jetbrains-mono
      pkgs.nerd-fonts.monaspace
      pkgs.nerd-fonts.jetbrains-mono
    ];
  };

  programs = (import ../../nix/hm_common.nix { inherit pkgs; }) // {
    # These are unique to the Mac
    zed-editor = import ../../nix/zed.nix;
    ghostty = import ../../nix/ghostty.nix { inherit pkgs; };
  };

  catppuccin = {
    enable = true;
    flavor = "latte";
    accent = "sky";
  };

  xdg.configFile = {
    nvim = {
      source = ../../config/nvim;
      target = "nvim";
    };
    zellij = {
      source = ../../config/zellij;
      target = "zellij";
    };
  };
}
