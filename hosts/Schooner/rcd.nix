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

  programs = {
    home-manager.enable = true;
    fish = import ../../nix/fish.nix { inherit pkgs; };
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    ghostty = import ../../nix/ghostty.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    zellij = import ../../nix/zellij.nix;
    bat = import ../../nix/bat.nix;
    zed-editor = import ../../nix/zed.nix;
    fzf = import ../../nix/fzf.nix;
    zoxide = import ../../nix/zoxide.nix;
    nh = import ../../nix/nh.nix;
    git = import ../../nix/git.nix;
    direnv = import ../../nix/direnv.nix;
    atuin = import ../../nix/atuin.nix;
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
      source = ../../config/zellij/Schooner;
      target = "zellij";
    };
  };
}
