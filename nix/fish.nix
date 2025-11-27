{ pkgs, ... }:
let
  commonShellInit = ''
    set -gx EDITOR nvim
    set -gx GOPATH $HOME/.local/go
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
    set -gx CLI_THEME "catppuccin"
    set -gx NH_FLAKE "$HOME/Code/Configs/dotfiles"

    fish_add_path $GOPATH/bin
    fish_add_path $HOME/.local/bin
  '';
in
{
  enable = true;

  shellInit =
    if pkgs.stdenv.isDarwin then
      ''
        ${commonShellInit}

        # See https://github.com/zed-industries/zed/issues/41806
        set -gx NODE_OPTIONS --experimental-sqlite
        fish_add_path /opt/homebrew/bin
        fish_add_path ~/.nix-profile/bin
        fish_add_path /nix/var/nix/profiles/default/bin
      ''
    else
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

    # Zellij
    zl = "zellij ls";
    za = "zellij a";
    zk = "zellij k";
    zka = "zellij ka";
  };

  functions = {
    zn = "zellij -s (basename (eval pwd))";
  };

  plugins = [
    {
      name = "grc";
      src = pkgs.fishPlugins.grc.src;
    }
  ];
}
