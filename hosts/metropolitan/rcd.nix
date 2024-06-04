{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../common/rcd_pub_key;
in {

  home = {
    username = "rcd";
    homeDirectory = "/home/rcd";
    stateVersion = "22.11";
    packages = import ../../common/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    neovim = import ../../common/neovim.nix { inherit pkgs; };
    fish = import ../../common/fish.nix { inherit pkgs; };
    tmux = import ../../common/tmux.nix;
    starship = import ../../common/starship.nix;
    zellij = import ../../common/zellij.nix;
    bat = import ../../common/bat.nix;

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
              "/mnt/c/Users/RCD/AppData/Local/1Password/app/8/op-ssh-sign.exe";
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
      enableFishIntegration = true;
      catppuccin = {
        enable = true;
        flavor = "frappe";
      };
    };
  };

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };
}
