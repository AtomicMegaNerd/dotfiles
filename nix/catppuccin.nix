{ config, lib, ... }:
let
  enable = true;
  flavor = config.amnOptions.catppuccin.flavor;
  accent = config.amnOptions.catppuccin.accent;
in
{
  catppuccin = {
    enable = enable;
    autoEnable = enable;
    flavor = lib.mkIf enable flavor;
    accent = lib.mkIf enable accent;
    # Neovim manages its own theme
    nvim.enable = false;
    # Lazygit's theme and settings are managed from static/common/lazygit.
    lazygit.enable = false;
    eza.enable = false;
    btop.enable = false;
    starship.enable = false;
    bat.enable = false;
  };

  home.sessionVariables = lib.mkIf enable {
    COLOR_THEME = "catppuccin";
    CATPPUCCIN_FLAVOR = "${flavor}";
    CATPPUCCIN_ACCENT = "${accent}";
  };
}
