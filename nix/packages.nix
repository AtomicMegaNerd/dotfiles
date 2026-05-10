{ pkgs }:
[
  # Basic cli utilities
  pkgs.curl
  pkgs.wget
  pkgs.dust
  pkgs.duf
  pkgs.grc
  pkgs.zip
  pkgs.unzip
  pkgs.jq
  pkgs.tree
  pkgs.glow

  # Global language servers, linters, and formatters
  pkgs.stylua
  pkgs.lua-language-server
  pkgs.yaml-language-server
  pkgs.prettier
  pkgs.markdownlint-cli2
  pkgs.nixfmt
  pkgs.nil
]
