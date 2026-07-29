{ lib, config, ... }:
let
  piThemeDir = "${config.xdg.configHome}/pi/agent/themes";
  catppuccinFlavor = config.amnOptions.catppuccin.flavor;
  catppuccinAccent = config.amnOptions.catppuccin.accent;
  catppuccinTheme = "catppuccin-${catppuccinFlavor}-${catppuccinAccent}";
  base16Theme = config.amnOptions.base16.theme;

  base16PiTheme = {
    "$schema" = "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    name = base16Theme;
    colors = with config.lib.stylix.colors.withHashtag; {
      accent = base0D;
      border = base03;
      borderAccent = base0D;
      borderMuted = base02;
      success = base0B;
      error = base08;
      warning = base0A;
      muted = base04;
      dim = base03;
      text = "";
      thinkingText = base04;

      selectedBg = base02;
      userMessageBg = base01;
      userMessageText = "";
      customMessageBg = base01;
      customMessageText = "";
      customMessageLabel = base0D;
      toolPendingBg = base00;
      toolSuccessBg = base01;
      toolErrorBg = base01;
      toolTitle = base0D;
      toolOutput = "";

      mdHeading = base0E;
      mdLink = base0D;
      mdLinkUrl = base0C;
      mdCode = base0B;
      mdCodeBlock = "";
      mdCodeBlockBorder = base03;
      mdQuote = base04;
      mdQuoteBorder = base03;
      mdHr = base03;
      mdListBullet = base0C;

      toolDiffAdded = base0B;
      toolDiffRemoved = base08;
      toolDiffContext = base04;

      syntaxComment = base03;
      syntaxKeyword = base0E;
      syntaxFunction = base0D;
      syntaxVariable = base08;
      syntaxString = base0B;
      syntaxNumber = base09;
      syntaxType = base0A;
      syntaxOperator = base0C;
      syntaxPunctuation = base05;

      thinkingOff = base03;
      thinkingMinimal = base0D;
      thinkingLow = base0C;
      thinkingMedium = base0B;
      thinkingHigh = base0A;
      thinkingXhigh = base09;
      thinkingMax = base08;

      bashMode = base0A;
    };
  };
in
{
  home.file."${piThemeDir}/${catppuccinTheme}.json" =
    lib.mkIf (config.amnOptions.theme == "catppuccin")
      {
        source = ../static/pi/themes/catppuccin/${catppuccinTheme}.json;
      };

  home.file."${piThemeDir}/${base16Theme}.json" = lib.mkIf (config.amnOptions.theme == "stylix") {
    text = builtins.toJSON base16PiTheme;
  };

  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";

    settings = {
      theme = if config.amnOptions.theme == "stylix" then base16Theme else catppuccinTheme;
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
