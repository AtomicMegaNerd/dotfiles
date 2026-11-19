{ ... }:
{
  programs.btop = {
    enable = true;
  };

  xdg.configFile."btop/btop.conf".source = ../static/common/btop/btop.conf;
  xdg.configFile."btop/themes/catppuccin_macchiato.theme".source =
    ../static/common/btop/themes/catppuccin_macchiato.theme;
}
