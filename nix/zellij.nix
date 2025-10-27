{ pkgs, ... }:
{
  enable = true;
  enableFishIntegration = false;

  settings = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
    copy_command = "pbcopy";
  };
}
