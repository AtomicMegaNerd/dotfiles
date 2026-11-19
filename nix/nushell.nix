{
  lib,
  pkgs,
  ...
}:
let
  isMac = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.nushell = {
    enable = true;
    loadSessionVariables = true;

    environmentVariables = {
      GOPATH = ''($env.XDG_DATA_HOME | path join "go")'';
      CARGO_HOME = ''($env.XDG_DATA_HOME | path join "cargo")'';
      EZA_CONFIG_DIR = ''($env.XDG_CONFIG_HOME | path join "eza")'';
      MANPAGER = "nvim +Man!";
      NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
    };

    extraEnv = ''
      use std/util "path add"
      path add ($env.GOPATH | path join "bin")
      path add "~/.local/bin"
      path add ($env.CARGO_HOME | path join "bin")
    ''
    + lib.optionalString isMac ''
      path add "/opt/homebrew/bin"
      path add "/Applications/Bear.app/Contents/MacOS"
    ''
    + ''
      # Rex puts rex on the PATH of its own terminals; shells started outside
      # Rex must re-add it (https://www.superlogical.com/rex/docs/automate/cli)
      if (($env.REX_BIN_DIR? | default "") | is-not-empty) { path add $env.REX_BIN_DIR }
    '';

    shellAliases = {
      df = "duf";
      cat = "bat --paging=never --style=plain";
      grep = "rg";
      vim = "nvim";
    };
  };
}
