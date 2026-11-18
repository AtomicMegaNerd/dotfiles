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

      # Disable telemetry and other nonessential traffic
      set -gx DISABLE_TELEMETRY 1
      set -gx DISABLE_ERROR_REPORTING 1
      set -gx DO_NOT_TRACK 1

      # On some systems eza may not use $XDG_CONFIG_HOME by default
      set -gx EZA_CONFIG_DIR $XDG_CONFIG_HOME/eza

      # Set man pager to neovim
      set -gx MANPAGER "nvim +Man!"

      # Extra CA bundle for Node.js tools
      set -gx NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt

      fish_add_path -g $GOPATH/bin
      fish_add_path -g $HOME/.local/bin
      fish_add_path -g $CARGO_HOME/bin
    ''
    + lib.optionalString isMac ''
      fish_add_path -g /opt/homebrew/bin
      fish_add_path -g /Applications/Bear.app/Contents/MacOS
    ''
    + ''
      # Rex puts rex on the PATH of its own terminals; shells started outside
      # Rex must re-add it (https://www.superlogical.com/rex/docs/automate/cli)
      if set -q REX_BIN_DIR; and test -n "$REX_BIN_DIR"
          fish_add_path --path --prepend --move $REX_BIN_DIR
      end
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
