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
  # Formatters
  stylua
  nixfmt-rfc-style
  # LSP
  nil
  lua-language-server
  nodePackages.markdownlint-cli
  nodePackages.prettier
]
