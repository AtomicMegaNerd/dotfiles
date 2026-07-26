{ config, lib, ... }:
let
  themeDir = "${config.xdg.configHome}/pi/agent/themes";

  # Load the original catppuccin theme as a template for the colors structure
  catppuccinTheme = builtins.fromJSON (builtins.readFile ../static/pi-catppuccin-frappe.json);

  # Map base16 colors onto pi's named palette vars.
  # The colors section in the JSON references these var names, so keeping
  # the same names lets us reuse the entire colors block unchanged.
  base16Vars = with config.lib.stylix.colors.withHashtag; {
    rosewater = base06;
    flamingo  = base0F;
    pink      = base0E;
    mauve     = base0E;
    red       = base08;
    maroon    = base08;
    peach     = base09;
    yellow    = base0A;
    green     = base0B;
    teal      = base0C;
    sky       = base0D;
    sapphire  = base0D;
    blue      = base0D;
    lavender  = base0E;
    text      = base05;
    subtext1  = base04;
    subtext0  = base03;
    overlay2  = base03;
    overlay1  = base02;
    overlay0  = base01;
    surface2  = base02;
    surface1  = base01;
    surface0  = base00;
    base      = base00;
    mantle    = base00;
    crust     = base00;
  };

  base16PiTheme = catppuccinTheme // {
    name = "stylix-base16";
    vars = base16Vars;
  };
in
{
  home.file."${themeDir}/catppuccin-frappe.json" = lib.mkIf (config.amnOptions.theme == "catppuccin") {
    source = ../static/pi-catppuccin-frappe.json;
  };

  home.file."${themeDir}/stylix-base16.json" = lib.mkIf (config.amnOptions.theme == "stylix") {
    text = builtins.toJSON base16PiTheme;
  };

  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";

    settings = {
      defaultProvider = "opencode-go";
      theme = if config.amnOptions.theme == "stylix" then "stylix-base16" else "catppuccin-frappe";
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
