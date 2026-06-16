{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
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

    home.activation.cloneNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      nvim_dir="${config.xdg.configHome}/nvim"
      if [ ! -d "$nvim_dir" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG \
          https://github.com/AtomicMegaNerd/rcd-nvim \
          "$nvim_dir"
      fi
    '';
  };
}
