{ config, ... }:
let
  themeDir = "${config.xdg.configHome}/pi/agent/themes";
in
{
  home.file."${themeDir}/catppuccin-frappe.json".source = ../static/pi-catppuccin-frappe.json;

  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";

    settings = {
      defaultProvider = "opencode-go";
      theme = "catppuccin-frappe";
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

    context = builtins.readFile ../static/pi-AGENTS.md;
  };
}
