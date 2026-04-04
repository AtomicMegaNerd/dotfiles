{ pkgs }:
[
  pkgs.fastfetch
  pkgs.glow
  pkgs.tldr
  pkgs.curl
  pkgs.wget
  pkgs.dust
  pkgs.duf
  pkgs.ripgrep
  pkgs.fd
  pkgs.grc
  pkgs.zip
  pkgs.unzip
  pkgs.procs
  pkgs.jq
  pkgs.nixfmt
  pkgs.nil
  pkgs.superfile
  pkgs.television
  pkgs.tree
  # tree-sitter 0.26.8 — override until nixpkgs/nixpkgs#506080 lands
  (pkgs.tree-sitter.overrideAttrs (old: rec {
    version = "0.26.8";
    src = pkgs.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      tag = "v${version}";
      hash = "sha256-fcFEfoALrbpBD6rWogxJ7FNVlvDQgswoX9ylRgko+8Q=";
      fetchSubmodules = true;
    };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-9FeWnWWPUWmMF15Psmul8GxGv2JceHWc2WZPmOr81gw=";
    };
    patches = [ ./tree-sitter-remove-web-interface.patch ];
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.rustPlatform.bindgenHook ];
  }))

  # Global LSP's and Linters
  pkgs.stylua
  pkgs.lua-language-server
  pkgs.yaml-language-server
  pkgs.prettier
  pkgs.markdownlint-cli2
]
