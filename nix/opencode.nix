{ pkgs, ... }:
let
  # TEMPORARY: nixpkgs #581607 shipped a bad node_modules hash for opencode 2.2.5.
  # Fixed upstream in #582675. Remove this override once nixpkgs-unstable includes
  # commit b38d8ba341b4610f45c4bf0aa9fbebcf7a9fc75c.
  opencodeFixed = pkgs.opencode.overrideAttrs (
    _final: prev: {
      node_modules = prev.node_modules.overrideAttrs {
        outputHash =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "sha256-dIveiaiPFGSItwLyeMuPDxTE9gpvvnlTCB/+nG24qCc="
          else
            "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
      };
    }
  );
in
{
  catppuccin.opencode.enable = false;

  programs.opencode = {
    enable = true;
    package = opencodeFixed;
    mutableSettings = true;
    context = ./../static/opencode/AGENTS.md;
    settings = builtins.fromJSON (builtins.readFile ./../static/opencode/opencode.json);
    cli = builtins.fromJSON (builtins.readFile ./../static/opencode/cli.json);
    agents = {
      rcd-go = ./../static/agents/rcd-go.md;
      rcd-nix = ./../static/agents/rcd-nix.md;
    };
  };
}
