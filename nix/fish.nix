{ pkgs, ... }:
let
  commonShellInit = ''
    set -gx GOPATH $HOME/.local/go
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
    set -gx CLI_THEME "catppuccin"
    set -gx XDG_DATA_HOME "$HOME/.local/share"
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
        set -gx DOCKER_HOST unix://(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)
        fish_add_path /opt/homebrew/bin
        fish_add_path ~/.nix-profile/bin
        fish_add_path /nix/var/nix/profiles/default/bin
        fish_add_path /Applications/Obsidian.app/Contents/MacOS
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

  plugins = [
    {
      name = "grc";
      src = pkgs.fishPlugins.grc.src;
    }
  ];
}
