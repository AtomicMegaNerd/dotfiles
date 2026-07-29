{ lib, ... }:
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
    amnOptions.catppuccin.flavor = lib.mkOption {
      type = lib.types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
    };
    amnOptions.catppuccin.accent = lib.mkOption {
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
  };

  # Here we can set the value we want
  config = {
    amnOptions.theme = "catppuccin";
    amnOptions.catppuccin.flavor = "frappe";
    amnOptions.catppuccin.accent = "sapphire";
  };
}
