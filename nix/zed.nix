{
  pkgs,
  lib,
  config,
  ...
}:
let
  zed_cfg_repo = "git@github.com:AtomicMegaNerd/rcd-zed.git";
  zed_cfg_src = "${config.home.homeDirectory}/Code/Configs/rcd-zed";
  zed_cfg_dest = "${config.xdg.configHome}/zed";
in
{
  # This code does two things:
  #
  # 1. Clone our rcd-zed config from its separate git repo to `~/Code/Configs/rcd-zed`
  # 2. Create a symlink to that repo from `~/.config/zed`.
  #
  # In both cases this will only happen if these files/links do not already exist.
  home.activation.setupzedConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${zed_cfg_src}" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "${zed_cfg_src}")"
      $DRY_RUN_CMD env GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh" \
        ${pkgs.git}/bin/git clone $VERBOSE_ARG ${zed_cfg_repo} "${zed_cfg_src}"
    fi
    if [ ! -e "${zed_cfg_dest}" ]; then
      $DRY_RUN_CMD ln -sf "${zed_cfg_src}" "${zed_cfg_dest}"
    fi
  '';
}
