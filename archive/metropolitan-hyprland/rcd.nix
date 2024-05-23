{ pkgs, ... }: {
  home.username = "rcd";
  home.homeDirectory = "/home/rcd";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  # Dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  gtk.enable = true;
  gtk.theme.name = "Adwaita-dark";

  home.packages = with pkgs; [
    fastfetch
    glow
    tldr
    wget
    curl
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
    fish
    dos2unix
    zoxide
  ];

  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.starship = import ../../common/starship.nix { inherit pkgs; };
  programs.fish = import ../../common/fish.nix { inherit pkgs; };
  programs.zellij = import ../../common/zellij.nix { inherit pkgs; };
  programs.tmux = import ../../common/tmux.nix { inherit pkgs; };
  programs.helix = import ../../common/helix.nix { inherit pkgs; };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Chris Dunphy";
    userEmail = "chris@megaparsec.ca";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.bat = {
    enable = true;
    config = { theme = "Nord"; };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = ''
      Host *
              IdentityAgent ~/.1password/agent.sock
    '';
  };

  xdg = {

    mimeApps = {
      enable = true;
      associations.added = { "text/html" = "firefox.desktop"; };
      defaultApplications = { "text/html" = "firefox.desktop"; };
    };

    configFile = {
      nvim = {
        source = ../../common/nvim;
        target = "nvim";
      };
      hypr = {
        source = ../../common/hypr;
        target = "hypr";
      };
      waybar = {
        source = ../../common/waybar;
        target = "waybar";
      };

      alacritty = {
        source = ../../common/alacritty;
        target = "alacritty";
      };
    };
  };
}
