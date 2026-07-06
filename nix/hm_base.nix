{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;

    # Imports with more complex logic
    btop = import ./btop.nix;
    direnv = import ./direnv.nix;
    eza = import ./eza.nix;
    fish = import ./fish.nix { inherit pkgs; };
    fzf = import ./fzf.nix;
    git = import ./git.nix;
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
    ripgrep.enable = true;
  };

  xdg = {
    enable = true;
    configFile."fish/themes/tokyonight-moon.theme".source = ../static/themes/fish/tokyonight-moon.theme;
    configFile."fish/themes/tokyonight-storm.theme".source =
      ../static/themes/fish/tokyonight-storm.theme;
  };

  # Neovim is a bit different
  imports = [
    ./neovim.nix
  ];
}
