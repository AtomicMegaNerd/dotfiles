{ config, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    configPath = "${config.xdg.configHome}/starship/starship.toml";
  };

  xdg.configFile."starship/starship.toml".source = ../static/common/starship/starship.toml;
}
