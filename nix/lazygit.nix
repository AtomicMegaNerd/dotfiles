{ ... }:
{
  programs.lazygit.enable = true;

  xdg.configFile."lazygit/config.yml".source = ../static/common/lazygit/config.yml;
}
