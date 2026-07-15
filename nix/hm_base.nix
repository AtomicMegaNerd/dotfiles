{ pkgs, lib, ... }:

let
  rcdPubKey = builtins.readFile ../static/rcd_pub_key;
in
{
  home.file.".ssh/allowed_signers" = lib.mkIf pkgs.stdenv.isDarwin {
    text = "${rcdPubKey}\n";
  };

  catppuccin = import ./catppuccin.nix;

  programs = {
    home-manager.enable = true;

    # Imports with more complex logic
    btop = import ./btop.nix;
    direnv = import ./direnv.nix;
    eza = import ./eza.nix;
    fish = import ./fish.nix { inherit pkgs; };
    fzf = import ./fzf.nix;
    git = import ./git.nix { inherit pkgs; };
    lazygit = import ./lazygit.nix;
    lazydocker = import ./lazydocker.nix;
    nh = import ./nh.nix;
    nushell = import ./nushell.nix;
    starship = import ./starship.nix;
    television = import ./television.nix;
    zellij = import ./zellij.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix;

    # Imports that are more basic
    bat.enable = true;
    fd.enable = true;
    nix-index.enable = true;
    ripgrep.enable = true;
  };

  xdg = {
    enable = true;
  };

  # Neovim is a bit different
  imports = [
    ./neovim.nix
  ];
}
