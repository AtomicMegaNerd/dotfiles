{ pkgs, ... }:
{
  imports = [ ./neovim.nix ];

  programs = {
    home-manager.enable = true;

    # Imports with more complex logic
    fish = import ./fish.nix { inherit pkgs; };
    zellij = import ./zellij.nix { inherit pkgs; };
    starship = import ./starship.nix;
    eza = import ./eza.nix;
    fzf = import ./fzf.nix;
    zoxide = import ./zoxide.nix;
    nh = import ./nh.nix;
    git = import ./git.nix;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bat.enable = true;
    fastfetch.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    superfile = true;
    television = true;
  };
  catppuccin = import ./catppuccin.nix;
  xdg.configFile = import ./xdg.nix;
}
