{
  config,
  pkgs,
  ...
}:
let
  mkAgentsMd = import ./lib/agents-md.nix { inherit pkgs; };
  piThemeDir = "${config.xdg.configHome}/pi/agent/themes";
  catppuccinTheme = config.amnOptions.catppuccin.theme;
in
{
  home.file."${piThemeDir}/${catppuccinTheme}.json" = {
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
      theme = catppuccinTheme;
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

    context = mkAgentsMd {
      template = ../static/agents-template.md;
      title = "Global Pi Agent Guidance";
    };
  };
}
