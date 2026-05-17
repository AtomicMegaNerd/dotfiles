{ pkgs, lib, ... }:

let
  rcdPubKey = builtins.readFile ../../static/rcd_pub_key;
in
{
  imports = [
    ../../nix/hm_base.nix
    ../../nix/zed.nix
  ];

  home = {
    username = "rcd";
    uid = 501;
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/allowed_signers".text = "${rcdPubKey}";
    file.".ssh/config".text = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

      Host 192.168.1.*
          ForwardAgent yes

      Host blahaj
          ForwardAgent yes
    '';
    packages = import ../../nix/packages.nix { inherit pkgs; } ++ [
      pkgs.monaspace
      pkgs.nerd-fonts.monaspace
      pkgs.github-mcp-server
      pkgs.docker-compose
      pkgs.nodejs # for claude-code
    ];
  };

  # This will write any secrets that we want to be global variables into
  # `~/.config/fish/conf.d/credentials.fish` which is in `.gitignore`.
  # I decided to remove the file each time rather than use --force
  home.activation.writeCredentials = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -x "/opt/homebrew/bin/op" ]]; then
      echo "cannot find op executable.."
      exit 1
    fi
    $DRY_RUN_CMD rm -f "$HOME/.config/fish/conf.d/credentials.fish"
    $DRY_RUN_CMD /opt/homebrew/bin/op inject \
      -i ${../../secrets/credentials.fish.tpl} \
      -o "$HOME/.config/fish/conf.d/credentials.fish"
  '';

  programs.ghostty = import ../../nix/ghostty.nix { inherit pkgs; };
  programs.claude-code = import ../../nix/claude.nix;
  programs.opencode = import ../../nix/opencode.nix;
  programs.crush = import ../../nix/crush.nix;
}
