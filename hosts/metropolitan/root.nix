{ config, pkgs, ... }:
{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.tmux = import ../../common/tmux.nix { inherit pkgs; };
  programs.starship = import ../../common/starship.nix { inherit pkgs; };
  programs.fish = import ../../common/fish.nix { inherit pkgs; };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };
}
