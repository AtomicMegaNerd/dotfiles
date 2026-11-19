{ pkgs, config, ... }:
{
  home.packages = [ pkgs.neovim ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink (
    "${config.home.homeDirectory}/Code/Configs/dotfiles/static/common/nvim"
  );
}
