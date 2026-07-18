{ lib, pkgs, ... }:
{
  # These are the custom options for my flake
  options = {
    amnOptions.isMac = lib.mkOption {
      type = lib.types.bool;
    };
  };

  config = {
    amnOptions.isMac = pkgs.stdenv.isDarwin;
  };
}
