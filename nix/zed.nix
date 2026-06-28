{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    home.activation.cloneZedConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      zed_dir="${config.xdg.configHome}/zed"
      if [ ! -d "$zed_dir" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG \
          https://github.com/AtomicMegaNerd/rcd-zed \
          "$zed_dir"
      fi
    '';
  };
}
