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
      extraPackages = with pkgs; [
        gcc
        nodejs-slim # Smaller nodejs for lsp's which don't need npm or npx
        tree-sitter
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
