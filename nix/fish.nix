{ pkgs, ... }:
let
  commonShellInit = ''
    set -gx EDITOR nvim
    set -gx GOPATH $HOME/.local/go
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
    set -gx CLI_THEME "catppuccin"
  '';
in {
  enable = true;

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  shellInit = commonShellInit;

  interactiveShellInit = ''
    set fish_greeting # Disable greeting
  '';

  shellAliases = {
    ls = "eza";
    ll = "eza -lah";
    df = "duf";
    cat = "bat --paging=never --style=plain";

    # Just use ripgrep
    grep = "rg";

    # Zellij
    zl = "zellij ls";
    za = "zellij a";
    zk = "zellij k";
    zka = "zellij ka";
  };

  functions = {
    tn = "tmux new -s (basename (eval pwd))";
    zn = "zellij -s (basename (eval pwd))";
  };

  plugins = [{
    name = "grc";
    src = pkgs.fishPlugins.grc.src;
  }];
}
