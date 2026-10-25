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

      # Disable Claude Code telemetry and other nonessential traffic
      set -gx CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC 1
      set -gx DISABLE_TELEMETRY 1
      set -gx DISABLE_ERROR_REPORTING 1
      set -gx DO_NOT_TRACK 1
      set -gx CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY 1
      set -gx CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL 1
      set -gx CLAUDE_CODE_ATTRIBUTION_HEADER 0
      set -gx CLAUDE_CODE_GATEWAY_HINT_HEADERS 0
      set -gx CLAUDE_CODE_MCP_ALLOWLIST_ENV 1

      # On some systems eza may not use $XDG_CONFIG_HOME by default
      set -gx EZA_CONFIG_DIR $XDG_CONFIG_HOME/eza

      # Set man pager to neovim
      set -gx MANPAGER "nvim +Man!"

      # Extra CA bundle for Node.js tools
      set -gx NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt

      if test -f $XDG_CONFIG_HOME/opencode/home-manager.json
        set -gx OPENCODE_CONFIG $XDG_CONFIG_HOME/opencode/home-manager.json
      end
      if test -f $XDG_CONFIG_HOME/opencode/home-manager-cli.json
        set -gx OPENCODE_CLI_CONFIG_CONTENT (cat $XDG_CONFIG_HOME/opencode/home-manager-cli.json)
      end

      fish_add_path -g $GOPATH/bin
      fish_add_path -g $HOME/.local/bin
      fish_add_path -g $CARGO_HOME/bin
    ''
    + lib.optionalString isMac ''
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
