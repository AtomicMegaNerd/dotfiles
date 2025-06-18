{ pkgs }:
with pkgs;
[
  fastfetch
  glow
  tldr
  curl
  wget
  du-dust
  duf
  htop
  ripgrep
  fd
  eza
  grc
  zip
  unzip
  procs
  jq
  dos2unix
  pre-commit
  podman-compose
  lazydocker
  # Linters
  golangci-lint
  ruff
  shellcheck
  # Formatters
  stylua
  nixfmt-rfc-style
  # LSP
  gopls
  pyright
  nil
  lua-language-server
  nodePackages.markdownlint-cli
  nodePackages.prettier
]
