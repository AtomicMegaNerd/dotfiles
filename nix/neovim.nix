{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    waylandSupport = false; # On blahaj we don't need this
    # This module always generates a little init.lua (it disables the ruby and
    # python providers) and would place it inside our out-of-store symlinked
    # config dir, which fails the home-manager-files build. Sideload it through
    # the wrapper's --cmd instead so ~/.config/nvim stays entirely ours.
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      gcc
      tree-sitter
      nodejs-slim
      cargo
      rustc
    ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink (
    "${config.home.homeDirectory}/Code/Configs/dotfiles/static/common/nvim"
  );
}
