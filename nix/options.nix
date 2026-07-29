{ lib, config, ... }:
let
  # This function pulls the palette from the canonical palette.json that ships with the
  # catppuccin flake. We can then re-use these colours for other apps where catppuccin/nvim
  # doesn't yet offer support.
  mkCatppuccinPalette =
    flavor: accent:
    let
      paletteData = lib.importJSON "${config.catppuccin.sources.palette}/palette.json";
      colors = paletteData.${flavor}.colors;
    in
    {
      base = colors.base.hex;
      mantle = colors.mantle.hex;
      crust = colors.crust.hex;
      surface0 = colors.surface0.hex;
      surface1 = colors.surface1.hex;
      surface2 = colors.surface2.hex;
      overlay0 = colors.overlay0.hex;
      overlay1 = colors.overlay1.hex;
      overlay2 = colors.overlay2.hex;
      subtext0 = colors.subtext0.hex;
      subtext1 = colors.subtext1.hex;
      text = colors.text.hex;
      lavender = colors.lavender.hex;
      blue = colors.blue.hex;
      sapphire = colors.sapphire.hex;
      sky = colors.sky.hex;
      teal = colors.teal.hex;
      green = colors.green.hex;
      yellow = colors.yellow.hex;
      peach = colors.peach.hex;
      maroon = colors.maroon.hex;
      red = colors.red.hex;
      mauve = colors.mauve.hex;
      pink = colors.pink.hex;
      flamingo = colors.flamingo.hex;
      rosewater = colors.rosewater.hex;
      accent = colors.${accent}.hex;
    };
in
{
  # These are the custom options for my flake. This let's us exercise more control over how
  # some parts of the system are configured.
  options = {
    amnOptions.theme = lib.mkOption {
      type = lib.types.enum [
        "catppuccin"
        "stylix"
      ];
    };
    amnOptions.stylix.theme = lib.mkOption {
      type = lib.types.str;
    };
    amnOptions.catppuccin = {
      theme = lib.mkOption {
        type = lib.types.str;
      };
      flavor = lib.mkOption {
        type = lib.types.enum [
          "latte"
          "frappe"
          "macchiato"
          "mocha"
        ];
      };
      accent = lib.mkOption {
        type = lib.types.enum [
          "blue"
          "flamingo"
          "green"
          "lavender"
          "maroon"
          "mauve"
          "peach"
          "pink"
          "red"
          "rosewater"
          "sapphire"
          "sky"
          "teal"
          "yellow"
        ];
      };
      palette = lib.mkOption {
        type = lib.types.anything;
        description = "Official catppuccin palette for the active flavor, using catppuccin color names.";
      };
    };
  };

  # Set the values for our confiuration here
  config = {
    amnOptions.theme = "catppuccin";
    amnOptions.stylix.theme = "gruvbox-dark-soft";
    amnOptions.catppuccin = rec {
      flavor = "frappe";
      accent = "sapphire";
      theme = "catppuccin-${flavor}-${accent}";
      palette = mkCatppuccinPalette flavor accent;
    };
  };
}
