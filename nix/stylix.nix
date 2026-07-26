{
  config,
  lib,
  pkgs,
  ...
}:
let
  enableStylix = (config.amnOptions.theme == "stylix");
  themeInput = config.stylix.inputs.tinted-schemes;
  theme = "gruvbox-dark-soft.yaml";
in
{
  stylix = {
    enable = enableStylix;
    autoEnable = enableStylix;
    base16Scheme = lib.mkIf enableStylix "${themeInput}/base16/${theme}";
    fonts = {
      monospace = {
        package = pkgs.monaspace;
        name = "Monaspace Argon";
      };
    };
    targets.neovim.enable = false;
  };

  # Bridge: expose the active base24 palette to our non-Nix neovim config.
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
