{ config, lib, ... }:
let
  enableCatppuccin = (config.amnOptions.theme == "catppuccin");
  catppuccinFlavor = config.amnOptions.catppuccin.flavor;
  catppuccinAccent = config.amnOptions.catppuccin.accent;
in
{
  catppuccin = {
    enable = enableCatppuccin;
    autoEnable = enableCatppuccin;
    flavor = lib.mkIf enableCatppuccin catppuccinFlavor;
    accent = lib.mkIf enableCatppuccin catppuccinAccent;
    nvim.enable = false;
  };

  home.sessionVariables = lib.mkIf enableCatppuccin {
    COLOR_THEME = "catppuccin";
    CATPPUCCIN_FLAVOR = "${catppuccinFlavor}";
    CATPPUCCIN_ACCENT = "${catppuccinAccent}";
  };
}
