{
  config,
  lib,
  ...
}:
let
  enableStylix = (config.amnOptions.theme == "stylix");
  themeInput = config.stylix.inputs.tinted-schemes;
  theme = "gruvbox-dark-soft.yaml";

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
  # We use this function to find every entry in config.stylix.targets
  # that has a font attribute. We then use this to set fonts.enable to false.
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
    };
  };

  # Bridge: expose the active base16 palette to our non-Nix neovim config.
  home.file."${config.xdg.configHome}/nvim/lua/rcd/stylix-colors.lua".text =
    with config.lib.stylix.colors.withHashtag; ''
      return {
        base00 = "${base00}", base01 = "${base01}", base02 = "${base02}", base03 = "${base03}",
        base04 = "${base04}", base05 = "${base05}", base06 = "${base06}", base07 = "${base07}",
        base08 = "${base08}", base09 = "${base09}", base0A = "${base0A}", base0B = "${base0B}",
        base0C = "${base0C}", base0D = "${base0D}", base0E = "${base0E}", base0F = "${base0F}",
      }
    '';
}
