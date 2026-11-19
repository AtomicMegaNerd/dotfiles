{ pkgs, ... }:
{
  home.packages = [ pkgs.lazygit ];

  xdg.configFile."lazygit/config.yml".source = ../static/common/lazygit/config.yml;
}
