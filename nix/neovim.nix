{
  pkgs,
  lib,
  config,
  ...
}:
let
  nvim_cfg_repo = "git@github.com:AtomicMegaNerd/rcd-nvim.git";
  nvim_cfg_src = "${config.home.homeDirectory}/Code/Configs/rcd-nvim";
  nvim_cfg_dest = "${config.xdg.configHome}/nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;
    waylandSupport = false; # On blahaj we don't need this
    extraPackages = with pkgs; [
      gcc
      tree-sitter
      nodejs-slim
    ];
  };

  # This code does two things:
  #
  # 1. Clone our rcd-nvim config from its separate git repo to `~/Code/Configs/rcd-nvim`
  # 2. Create a symlink to that repo from `~/.config/nvim`.
  #
  # In both cases this will only happen if these files/links do not already exist.
  home.activation.setupNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${nvim_cfg_src}" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "${nvim_cfg_src}")"
      $DRY_RUN_CMD env GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh" \
        ${pkgs.git}/bin/git clone $VERBOSE_ARG ${nvim_cfg_repo} "${nvim_cfg_src}"
    fi

    if [ ! -e "${nvim_cfg_dest}" ]; then
      $DRY_RUN_CMD ln -sf "${nvim_cfg_src}" "${nvim_cfg_dest}"
    fi
  '';
}
