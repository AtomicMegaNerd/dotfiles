{
  config,
  lib,
  ...
}:
let
  isMac = config.amnOptions.isMac;
in
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting

      set -gx GOPATH $XDG_DATA_HOME/go
      set -gx CARGO_HOME $XDG_DATA_HOME/cargo
      set -gx NH_FLAKE $HOME/Code/Configs/dotfiles

      # on some systems eza may not use $XDG_CONFIG_HOME by default
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
      zl = "zellij ls";
      za = "zellij a";
      zk = "zellij k";
      zka = "zellij ka";
    };

    functions = {
      zn = ''
        set -l session_name (string sub -l 12 -- (basename $PWD))
        set -l layout_file

        if test -d ./.zellij
            set layout_file (find ./.zellij -maxdepth 1 -type f -name '*.kdl' | head -n 1)
        end

        if zellij list-sessions 2>/dev/null | awk '{print $1}' | grep -Fq -- "$session_name"
            echo "Attaching to existing Zellij session: $session_name"
            zellij attach "$session_name"
        else
            echo "Creating new Zellij session: $session_name"

            if test -n "$layout_file"
                zellij --new-session-with-layout "$layout_file" --session "$session_name"
            else
                zellij --session "$session_name"
            end
        end
      '';
    };
  };
}
