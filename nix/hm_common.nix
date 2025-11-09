{ pkgs }:
{
  home-manager.enable = true;
  fish = import ./fish.nix { inherit pkgs; };
  neovim = import ./neovim.nix { inherit pkgs; };
  zellij = import ./zellij.nix { inherit pkgs; };
  starship = import ./starship.nix;
  eza = import ./eza.nix;
  bat = import ./bat.nix;
  fzf = import ./fzf.nix;
  zoxide = import ./zoxide.nix;
  nh = import ./nh.nix;
  git = import ./git.nix;
  direnv = import ./direnv.nix;
  bottom = import ./bottom.nix;
}
