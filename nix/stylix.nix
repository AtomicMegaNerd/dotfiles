{
  config,
  lib,
  ...
}:
let
  enableStylix = (config.amnOptions.theme == "stylix");
  theme = config.amnOptions.stylix.theme;
  themeFile = "${config.stylix.inputs.tinted-schemes}/base16/${theme}.yaml";

  # We will do explicit opt-in for theming here. Also please note we leave neovim out of this
  # as we do not configure neovim with nix.
  targetList = [
    "bat"
    "btop"
    "fish"
    "fzf"
    "ghostty"
    "lazygit"
    "nushell"
    "opencode"
    "starship"
    "zellij"
  ];

  # We want to enable all selected targets, but for the targets that have font configurations
  # we want to disable stylix for managing fonts.
  enableStylixTargets = lib.genAttrs targetList (
    name:
    {
      enable = true;
    }
    // lib.optionalAttrs (config.stylix.targets.${name} ? fonts) { fonts.enable = false; }
  );
in
{
  stylix = {
    enable = enableStylix;
    autoEnable = false; # Do not use autoEnable
    base16Scheme = lib.mkIf enableStylix "${themeFile}";
    targets = enableStylixTargets;
  };

  # For all of the base16 themes we set each color to an environment variable. We also
  # set color theme
  home.sessionVariables = lib.mkIf enableStylix (
    with config.lib.stylix.colors.withHashtag;
    {
      COLOR_THEME = "stylix";
      BASE16_COLOR_00 = base00;
      BASE16_COLOR_01 = base01;
      BASE16_COLOR_02 = base02;
      BASE16_COLOR_03 = base03;
      BASE16_COLOR_04 = base04;
      BASE16_COLOR_05 = base05;
      BASE16_COLOR_06 = base06;
      BASE16_COLOR_07 = base07;
      BASE16_COLOR_08 = base08;
      BASE16_COLOR_09 = base09;
      BASE16_COLOR_0A = base0A;
      BASE16_COLOR_0B = base0B;
      BASE16_COLOR_0C = base0C;
      BASE16_COLOR_0D = base0D;
      BASE16_COLOR_0E = base0E;
      BASE16_COLOR_0F = base0F;
    }
  );
}
