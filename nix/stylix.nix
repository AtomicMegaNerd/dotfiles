{
  config,
  lib,
  ...
}:
let
  enableStylix = (config.amnOptions.theme == "stylix");
  themeInput = config.stylix.inputs.tinted-schemes;
  theme = "gruvbox-dark-soft.yaml";

  isMac = config.amnOptions.isMac;
  hasGui = config.amnOptions.hasGui;

  # Notes on this hairy bit of Nix:
  #
  # mapAttrs calls a function on each entry in an AttrSet. The function we pass to mapAttrs  must
  # take the name of the entry and its value as arguments.
  #
  # In this case we ignore the name of the entry. Because the entries we are interested in are
  # themselves attrSets we call another function: optionalAttrs which takes a bool and an AttrSet
  # as arguments. if the bool is true optionalAttrs returns the AttrSet argument otherwise
  # returns an empty AttrSet {}.
  #
  # (val ? fonts) returns true if the AttrSet named val has an entry named fonts.
  #
  # We call this function over config.stylix.targets which will set fonts.enable = false
  # for any entry that itself contains a fonts entry. The result returned is an AttrSet.
  disableFonts = lib.mapAttrs (
    _name: val: lib.optionalAttrs (val ? fonts) { fonts.enable = false; }
  ) config.stylix.targets;

in
{
  stylix = {
    enable = enableStylix;
    autoEnable = enableStylix;
    base16Scheme = lib.mkIf enableStylix "${themeInput}/base16/${theme}";
    targets = disableFonts // {
      neovim.enable = false;
      gtk.enable = hasGui; # Disable gtk if this system has no gui or is a Mac
      qt.enable = hasGui; # Disable qt if this system has no gui or is a Mac
    };
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
