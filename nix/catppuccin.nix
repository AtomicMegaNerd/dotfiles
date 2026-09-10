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
  };

  home.sessionVariables = lib.mkIf enable {
    COLOR_THEME = "catppuccin";
    CATPPUCCIN_FLAVOR = "${flavor}";
    CATPPUCCIN_ACCENT = "${accent}";
  };
}
