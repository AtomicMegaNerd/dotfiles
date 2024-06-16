{ pkgs, ... }:
let
  commonShellInit = ''
    set -gx EDITOR nvim
    set -gx GOPATH $HOME/.local/go
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
  '';
in {
  enable = true;

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

  shellInit = if pkgs.stdenv.isDarwin then ''
    ${commonShellInit}

    # Fixes color bug on MacOS
    set -gx TERMINFO_DIRS $TERMINFO_DIRS:$HOME/.local/share/terminfo

    # Enable Homebrew for casks
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
    fish_add_path ~/.nix-profile/bin
    fish_add_path /nix/var/nix/profiles/default/bin
  '' else
    commonShellInit;

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

    tl = "tmux list-sessions";
    ta = "tmux attach";
    tk = "tmux kill-session";
    tka = "tmux kill-server";

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
