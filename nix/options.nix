{ lib, ... }:
let
  catppuccinPalettes = {
    latte = {
      bg = "#eff1f5";
      panel = "#e6e9ef";
      panelAlt = "#dce0e8";
      selected = "#ccd0da";
      border = "#acb0be";
      cyan = "#179299";
      green = "#40a02b";
      red = "#d20f39";
      yellow = "#df8e1d";
      orange = "#fe640b";
      purple = "#8839ef";
      text = "#4c4f69";
      muted = "#6c6f85";
      dim = "#8c8fa1";
      toolSuccessBg = "#c3ddc3";
      toolErrorBg = "#e8b9c6";
      accents = {
        blue = "#1e66f5";
        flamingo = "#dd7878";
        green = "#40a02b";
        lavender = "#7287fd";
        maroon = "#e64553";
        mauve = "#8839ef";
        peach = "#fe640b";
        pink = "#ea76cb";
        red = "#d20f39";
        rosewater = "#dc8a78";
        sapphire = "#209fb5";
        sky = "#04a5e5";
        teal = "#179299";
        yellow = "#df8e1d";
      };
    };
    frappe = {
      bg = "#303446";
      panel = "#292c3c";
      panelAlt = "#232634";
      selected = "#414559";
      border = "#626880";
      cyan = "#81c8be";
      green = "#a6d189";
      red = "#e78284";
      yellow = "#e5c890";
      orange = "#ef9f76";
      purple = "#ca9ee6";
      text = "#c6d0f5";
      muted = "#a5adce";
      dim = "#838ba7";
      toolSuccessBg = "#4e5b56";
      toolErrorBg = "#5e4855";
      accents = {
        blue = "#8caaee";
        flamingo = "#eebebe";
        green = "#a6d189";
        lavender = "#babbf1";
        maroon = "#ea999c";
        mauve = "#ca9ee6";
        peach = "#ef9f76";
        pink = "#f4b8e4";
        red = "#e78284";
        rosewater = "#f2d5cf";
        sapphire = "#85c1dc";
        sky = "#99d1db";
        teal = "#81c8be";
        yellow = "#e5c890";
      };
    };
    macchiato = {
      bg = "#24273a";
      panel = "#1e2030";
      panelAlt = "#181926";
      selected = "#363a4f";
      border = "#5b6078";
      cyan = "#8bd5ca";
      green = "#a6da95";
      red = "#ed8796";
      yellow = "#eed49f";
      orange = "#f5a97f";
      purple = "#c6a0f6";
      text = "#cad3f5";
      muted = "#a5adcb";
      dim = "#8087a2";
      toolSuccessBg = "#455450";
      toolErrorBg = "#563f51";
      accents = {
        blue = "#8aadf4";
        flamingo = "#f0c6c6";
        green = "#a6da95";
        lavender = "#b7bdf8";
        maroon = "#ee99a0";
        mauve = "#c6a0f6";
        peach = "#f5a97f";
        pink = "#f5bde6";
        red = "#ed8796";
        rosewater = "#f4dbd6";
        sapphire = "#7dc4e4";
        sky = "#91d7e3";
        teal = "#8bd5ca";
        yellow = "#eed49f";
      };
    };
    mocha = {
      bg = "#1e1e2e";
      panel = "#181825";
      panelAlt = "#11111b";
      selected = "#313244";
      border = "#585b70";
      cyan = "#94e2d5";
      green = "#a6e3a1";
      red = "#f38ba8";
      yellow = "#f9e2af";
      orange = "#fab387";
      purple = "#cba6f7";
      text = "#cdd6f4";
      muted = "#a6adc8";
      dim = "#7f849c";
      toolSuccessBg = "#404f4a";
      toolErrorBg = "#53394c";
      accents = {
        blue = "#89b4fa";
        flamingo = "#f2cdcd";
        green = "#a6e3a1";
        lavender = "#b4befe";
        maroon = "#eba0ac";
        mauve = "#cba6f7";
        peach = "#fab387";
        pink = "#f5c2e7";
        red = "#f38ba8";
        rosewater = "#f5e0dc";
        sapphire = "#74c7ec";
        sky = "#89dceb";
        teal = "#94e2d5";
        yellow = "#f9e2af";
      };
    };
  };

  mkCatppuccinPalette =
    flavor: accent:
    let
      palette = catppuccinPalettes.${flavor};
    in
    palette // { accent = palette.accents.${accent}; };
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
        description = "Palette for the active catppuccin flavor.";
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
