{
  lib,
  pkgs,
  ...
}:
let
  isMac = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting
      set -gx GOPATH $XDG_DATA_HOME/go
      set -gx CARGO_HOME $XDG_DATA_HOME/cargo
      set -gx NH_FLAKE $HOME/Code/Configs/dotfiles

      # On some systems eza may not use $XDG_CONFIG_HOME by default
      set -gx EZA_CONFIG_DIR $XDG_CONFIG_HOME/eza

      # Set man pager to neovim
      set -gx MANPAGER "nvim +Man!"

      fish_add_path -g $GOPATH/bin
      fish_add_path -g $HOME/.local/bin
      fish_add_path -g $CARGO_HOME/bin
    ''
    + lib.optionalString isMac ''
      set -gx DOCKER_HOST \
        unix://(podman machine inspect \
        --format '{{.ConnectionInfo.PodmanSocket.Path}}' \
        2>/dev/null)
      fish_add_path -g /opt/homebrew/bin
      fish_add_path -g /Applications/Bear.app/Contents/MacOS
    '';

    shellAliases = {
      ls = "eza";
      ll = "eza -lah";
      df = "duf";
      cat = "bat --paging=never --style=plain";
      grep = "rg";
    };
  };
}
