{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    waylandSupport = false; # On blahaj we don't need this
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
