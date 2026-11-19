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
    # These programs' themes/settings are owned by static files in
    # static/common/<program>; the generated files would collide with our
    # xdg.configFile entries (catppuccin autoEnable otherwise themes
    # everything it detects).
    lazygit.enable = false;
    eza.enable = false;
    btop.enable = false;
    starship.enable = false;
  };

  home.sessionVariables = lib.mkIf enable {
    COLOR_THEME = "catppuccin";
    CATPPUCCIN_FLAVOR = "${flavor}";
    CATPPUCCIN_ACCENT = "${accent}";
  };
}
