{ lib, pkgs, ... }:
{
  # These are the custom options for my flake
  options = {
    amnOptions.isMac = lib.mkOption {
      type = lib.types.bool;
    };

    amnOptions.theme = lib.mkOption {
      type = lib.types.enum [
        "catppuccin"
        "stylix"
      ];
      default = "stylix";
      description = "Global theme selector. Switches between catppuccin and stylix (base16) theming.";
    };
  };

  config = {
    amnOptions.isMac = pkgs.stdenv.isDarwin;
  };
}
