{ ... }:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };

  xdg.configFile."eza/theme.yml".source = ../static/common/eza/theme.yml;
}
