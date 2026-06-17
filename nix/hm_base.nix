{ pkgs, ... }:
{
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
    direnv = import ./direnv.nix;
    btop = import ./btop.nix;
    lazygit = import ./lazygit.nix;
    lazydocker = import ./lazydocker.nix;

    # Imports that are more basic
    bat.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
  };

  xdg = {
    enable = true;
    configFile."fish/themes/tokyonight-moon.theme".source = ../static/themes/fish/tokyonight-moon.theme;
    configFile."fish/themes/tokyonight-storm.theme".source =
      ../static/themes/fish/tokyonight-storm.theme;
  };

  # Neovim is a bit different
  imports = [ ./neovim.nix ];
}
