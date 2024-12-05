{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
    fish = import ../../nix/fish.nix { inherit pkgs; };
    starship = import ../../nix/starship.nix;
    zellij = import ../../nix/zellij.nix;
    bat = import ../../nix/bat.nix;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Chris Dunphy";
      userEmail = "chris@megaparsec.ca";
      extraConfig = {
        core.sshCommand = "ssh.exe";
        init.defaultBranch = "main";
        pull.rebase = false;
        user.signingkey = "${rcd_pub_key}";
        gpg = {
          ssh = {
            program =
              "/mnt/c/Users/chris/AppData/Local/1Password/app/8/op-ssh-sign.exe";
          };
          format = "ssh";
        };
        commit = { gpgsign = true; };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
    };
  };

  xdg.configFile = {
    nvim = {
      source = ../../config/nvim;
      target = "nvim";
    };
    zellij = {
      source = ../../config/zellij/metropolitan;
      target = "zellij";
    };
  };
}
