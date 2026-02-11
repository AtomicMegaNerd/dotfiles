{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    fish = import ./fish.nix { inherit pkgs; };
    neovim = import ./neovim.nix { inherit pkgs; };
    zellij = import ./zellij.nix { inherit pkgs; };
    starship = import ./starship.nix;
    eza = import ./eza.nix;
    bat.enable = true;
    fzf = import ./fzf.nix;
    zoxide = import ./zoxide.nix;
    nh = import ./nh.nix;
    git = import ./git.nix;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bottom.enable = true;
  };
  catppuccin = import ./catppuccin.nix;
  xdg.configFile = import ./xdg.nix;
}
