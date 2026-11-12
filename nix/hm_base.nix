{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./agent-skills.nix
    ./btop.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./herdr.nix
    ./catppuccin.nix
    ./lazygit.nix
    ./lazydocker.nix
    ./neovim.nix
    ./nushell.nix
    ./starship.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
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

    # Additional nix tooling
    nix-graph
    nix-tree

    # Common linters and LSP servers
    bash-language-server
    yaml-language-server
    yamllint
    nil
    nixfmt
    tombi
    oxfmt
    markdownlint-cli2
  ];

  programs = {
    home-manager.enable = true;

    # Cleaning is scheduled by nix-darwin on Schooner, so no clean config here
    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/Code/Configs/dotfiles";
    };

    # Imports that don't need additional configuration
    bat.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    fd.enable = true;
    ripgrep.enable = true;
  };

  # We always want to use the XDG standards when possible even on the Mac.
  xdg = {
    enable = true;
  };
}
