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

    # The idea here is to clone our neovim config to ~/Code/Configs/rcd-nvim
    # but then to create a symlink to there from ~/.config/nvim.
    # I keep the configuration out of Nix because the lua is 100% fine and I can
    # make live edits to the config without having to re-run `nh home switch .`
    # This will only clone the repo if it is missing. It will also only create
    # the symlinks if they are missing.
    home.activation.setupNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      nvim_src="${config.home.homeDirectory}/Code/Configs/rcd-nvim"
      nvim_dst="${config.xdg.configHome}/nvim"

      if [ ! -d "$nvim_src" ]; then
        $DRY_RUN_CMD mkdir -p "$(dirname "$nvim_src")"
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG \
          https://github.com/AtomicMegaNerd/rcd-nvim \
          "$nvim_src"
      fi

      if [ ! -e "$nvim_dst" ]; then
        $DRY_RUN_CMD ln -sf "$nvim_src" "$nvim_dst"
      fi
    '';
  };
}
