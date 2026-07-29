{ lib, config, ... }:
let
  piThemeDir = "${config.xdg.configHome}/pi/agent/themes";
  theme = config.amnOptions.theme;
  stylixTheme = config.amnOptions.stylix.theme;
  catppuccinTheme = config.amnOptions.catppuccin.theme;
in
{
  home.file."${piThemeDir}/${stylixTheme}.json" = lib.mkIf (theme == "stylix") {
    text = builtins.toJSON (
      import ./pi-stylix.nix {
        name = stylixTheme;
        colors = config.lib.stylix.colors.withHashtag;
      }
    );
  };
  home.file."${piThemeDir}/${catppuccinTheme}.json" = lib.mkIf (theme == "catppuccin") {
    text = builtins.toJSON (
      import ./pi-catppuccin.nix {
        theme = catppuccinTheme;
        palette = config.amnOptions.catppuccin.palette;
      }
    );
  };

  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";

    settings = {
      theme = if theme == "stylix" then stylixTheme else catppuccinTheme;
      defaultProvider = "opencode-go";
      defaultThinkingLevel = "medium";
      compaction = {
        enabled = true;
        reserveTokens = 16384;
        keepRecentTokens = 20000;
      };
      retry = {
        enabled = true;
        maxRetries = 3;
      };
    };

    context = builtins.readFile ../static/pi/AGENTS.md;
  };
}
