{ pkgs }:
with pkgs; [
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
  gh
  # Linters
  golangci-lint
  ruff
  shellcheck
  # Formatters
  stylua
  alejandra
  # LSP
  gopls
  nil
  bash-language-server
  lua-language-server
  nodePackages.markdownlint-cli
  nodePackages.yaml-language-server
  nodePackages.prettier
]
