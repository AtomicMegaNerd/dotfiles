{ pkgs, ... }:
{
  # The home-manager lazygit module unconditionally claims
  # $XDG_CONFIG_HOME/lazygit/config.yml (its `settings` generation), which
  # conflicts with our static file. Install the package directly and keep the
  # config in static/common/lazygit/config.yml like our other static programs.
  home.packages = [ pkgs.lazygit ];

  xdg.configFile."lazygit/config.yml".source = ../static/common/lazygit/config.yml;
}
