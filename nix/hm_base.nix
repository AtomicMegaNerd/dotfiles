{
  lib,
  pkgs,
  ...
}:
let
  isMac = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./stylix.nix
    ./catppuccin.nix
    ./lazygit.nix
    ./lazydocker.nix
    ./neovim.nix
    ./nh.nix
    ./nushell.nix
    ./starship.nix
    ./television.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  config = {

    home = {
      packages =
        (with pkgs; [
          # Basic cli utilities
          curl
          wget
          dust
          duf
          zip
          unzip
          procs
          jq
          tree
          glow
          slumber

          # Common linters and LSP servers
          # .sh
          bash-language-server
          # .yaml
          yaml-language-server
          yamllint
          # .nix
          nil
          nixfmt
          # .toml
          tombi
          # .json
          biome
          # .md
          oxfmt
          markdownlint-cli2
          marksman
        ])
        # We only install these packages on our Mac systems
        ++ lib.optionals isMac (
          with pkgs;
          [
            docker-compose
            podman
            gh
          ]
        );
    };

    programs = {
      home-manager.enable = true;

      # Imports that don't need additional configuration
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
    };

    # We always want to use the XDG standards when possible even on the Mac.
    xdg = {
      enable = true;
    };
  };
}
