{
  lib,
  pkgs,
  ...
}:
let
  isMac = pkgs.stdenv.isDarwin;
in
{
  programs.nushell = {
    enable = true;

    environmentVariables = {
      GOPATH = ''($env.XDG_DATA_HOME | path join "go")'';
      CARGO_HOME = ''($env.XDG_DATA_HOME | path join "cargo")'';
      NH_FLAKE = ''($env.HOME | path join "Code/Configs/dotfiles")'';
      EZA_CONFIG_DIR = ''($env.XDG_CONFIG_HOME | path join "eza")'';
      MANPAGER = "nvim +Man!";
    };

    extraEnv = ''
      use std/util "path add"
      path add ($env.GOPATH | path join "bin")
      path add "~/.local/bin"
      path add ($env.CARGO_HOME | path join "bin")
    ''
    + lib.optionalString isMac ''
      $env.DOCKER_HOST = (try {
        ^podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}'
      } catch { "" })
      path add "/opt/homebrew/bin"
      path add "/Applications/Bear.app/Contents/MacOS"
    '';

    shellAliases = {
      df = "duf";
      cat = "bat --paging=never --style=plain";
      grep = "rg";
    };
  };
}
