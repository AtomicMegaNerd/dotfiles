{ pkgs, lib, ... }: {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  services = {
    hypridle = import ../../nix/hypridle.nix;
    hyprpaper = import ../../nix/hyprpaper.nix;

    mako = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "frappe";
      };
    };
  };

  wayland.windowManager.hyprland =
    import ../../nix/hyprland.nix { inherit pkgs; };

  programs = {
    home-manager.enable = true;
    fish = import ../../nix/fish.nix { inherit pkgs; };
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    zellij = import ../../nix/zellij.nix;
    tmux = import ../../nix/tmux.nix;
    alacritty = import ../../nix/alacritty.nix;
    bat = import ../../nix/bat.nix;
    waybar = import ../../nix/waybar.nix { inherit lib; };
    hyprlock = import ../../nix/hyprlock.nix;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Chris Dunphy";
      userEmail = "chris@megaparsec.ca";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      catppuccin = {
        enable = true;
        flavor = "frappe";
      };
    };

    ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        Host *
                IdentityAgent ~/.1password/agent.sock
      '';
    };
  };

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "frappe";
      accent = "teal";
      icon = {
        enable = true;
        flavor = "frappe";
        accent = "teal";
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      associations.added = { "text/html" = "firefox.desktop"; };
      defaultApplications = { "text/html" = "firefox.desktop"; };
    };
    configFile = {
      nvim = {
        source = ../../config/nvim;
        target = "nvim";
      };
    };
  };
}
