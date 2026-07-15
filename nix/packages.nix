{ pkgs }:
[
  # Basic cli utilities

  pkgs.curl
  pkgs.wget
  pkgs.dust
  pkgs.duf
  pkgs.zip
  pkgs.unzip
  pkgs.procs
  pkgs.jq
  pkgs.tree
  pkgs.glow

  # Common linters and LSP servers

  # .sh
  pkgs.bash-language-server

  # .yaml
  pkgs.yaml-language-server
  pkgs.yamllint

  # .nix
  pkgs.nixfmt
  pkgs.nil

  # .json
  pkgs.oxfmt

  # .md
  pkgs.biome
  pkgs.markdownlint-cli2
]
