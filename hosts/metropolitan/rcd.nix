{ pkgs, ... }: {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "24.11";

    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    fish = import ../../nix/fish.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    zellij = import ../../nix/zellij.nix;
    bat = import ../../nix/bat.nix;

		nh = { 
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

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
        credential = {
         helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
          "https://github.com".username = "AtomicMegaNerd";
          credentialStore = "cache";
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = { enable = true; };
  };

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  xdg.configFile = {
    nvim = {
      source = ../../config/nvim;
      target = "nvim";
    };
    zellij = {
      source = ../../config/zellij/linux;
      target = "zellij";
    };
  };
}
