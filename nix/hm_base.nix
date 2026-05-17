{
  pkgs,
  ...
}:
{
  home.shell.enableFishIntegration = true;
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

    # Imports that are more basic
    bat.enable = true;
    fastfetch.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
  };
  imports = [ ./neovim.nix ];
  catppuccin = import ./catppuccin.nix;
}
