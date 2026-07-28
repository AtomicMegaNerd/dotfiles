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
      description = "Global theme selector. Switches between catppuccin and stylix theming.";
    };
  };

  # Here we can set the value we want
  config = {
    amnOptions.theme = "catppuccin";
  };
}
