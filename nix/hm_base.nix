{
  pkgs,
  lib,
  config,
  ...
}:
let
  # We can declare an alias for our flags even before we define them!
  flags = config.flags;
in
{

  # We can setup a series of flags for our systems for conditional logic.
  options.flags = {
    isLinux = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
    };
    isMac = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.stdenv.isDarwin;
    };
  };

  # Neovim is a bit different than the programs below because I don't want to have to run
  # `nh home switch .` every time I make a change to the lua config. This flake installs
  # the neovim package but clones the lua config from github.com/atomicmeganerd/rcd-nvim
  imports = [
    ./neovim.nix
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
          oxfmt
          # .md
          biome
          markdownlint-cli2
        ])
        # TODO: See if this is the best way to optionally append items to the list.
        ++ lib.optionals flags.isMac (
          with pkgs;
          [
            docker-compose
            podman
            gh
          ]
        );
    };

    # This is for configuring the catppuccin home manager module.
    catppuccin = import ./catppuccin.nix;

    programs = {
      home-manager.enable = true;

      # Imports with more complex logic
      btop = import ./btop.nix;
      direnv = import ./direnv.nix;
      eza = import ./eza.nix;
      fzf = import ./fzf.nix;
      lazygit = import ./lazygit.nix;
      lazydocker = import ./lazydocker.nix;
      nh = import ./nh.nix;
      nushell = import ./nushell.nix;
      starship = import ./starship.nix;
      television = import ./television.nix;
      zoxide = import ./zoxide.nix;
      # These imports take additional flags
      fish = import ./fish.nix { inherit flags; };
      git = import ./git.nix { inherit flags lib; };
      zellij = import ./zellij.nix { inherit flags lib; };

      # Imports that don't need additional configuration
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;

      # We can use our flags to determine if we import these modules or not
      ghostty = lib.mkIf flags.isMac (import ./ghostty.nix);
      opencode = lib.mkIf flags.isMac (import ./opencode.nix { inherit lib; });
    };

    # We always want to use the XDG standards when possible even on the Mac.
    xdg = {
      enable = true;
    };
  };
}
