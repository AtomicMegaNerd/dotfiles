{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../common/rcd_pub_key;
in {
  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "23.11";
    file.".ssh/allowed_signers".text = "${rcd_pub_key}";
    packages = import ../../common/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    fish = import ../../common/fish.nix { inherit pkgs; };
    neovim = import ../../common/neovim.nix { inherit pkgs; };
    tmux = import ../../common/tmux.nix;
    starship = import ../../common/starship.nix;
    zellij = import ../../common/zellij.nix;
    alacritty = import ../../common/alacritty.nix;
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
        init.defaultBranch = "main";
        pull.rebase = false;
        core.editor = "nvim";
        gpg.format = "ssh";
        gpg.ssh = {
          allowedSignersFile = "/Users/rcd/.ssh/allowed_signers";
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
        user.signingkey = "${rcd_pub_key}";
        commit.gpgsign = true;
        push.autoSetupRemote = true;
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
