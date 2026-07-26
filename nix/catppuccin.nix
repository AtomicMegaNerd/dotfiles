{ config, lib, ... }:
let
  enableCatppuccin = (config.amnOptions.theme == "catppuccin");
in
{
  catppuccin = {
    enable = enableCatppuccin;
    autoEnable = enableCatppuccin;
    flavor = lib.mkIf enableCatppuccin "frappe";
    accent = lib.mkIf enableCatppuccin "sapphire";
    nvim.enable = false;
  };

  home.sessionVariables = lib.mkIf enableCatppuccin { COLOR_THEME = "catppuccin"; };
}
