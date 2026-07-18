{
  pkgs,
  lib,
  config,
  ...
}:
let
  isMac = config.amnOptions.isMac;
in
{

  # Each of these is a self-contained Nix module that sets its own `programs.<name>`
  # (or `catppuccin` for catppuccin.nix). Host-specific modules (ghostty, opencode)
  # are imported by the host's rcd.nix instead of here, so a host opts in by import,
  # not by a runtime flag. See docs/dendritic.md (the `enable` anti-pattern).
  imports = [
    ./btop.nix
    ./catppuccin.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
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

          # Common linters and LSP servers
          # .sh
          bash-language-server
          # .yaml
          yaml-language-server
          yamllint
          # .nix
          nixfmt
          nil
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
