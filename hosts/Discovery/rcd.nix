{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {
  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "24.11";
    file.".ssh/allowed_signers".text = "${rcd_pub_key}";
    packages = import ../../nix/packages.nix { inherit pkgs; };
  };

  programs = {
    home-manager.enable = true;
    fish = import ../../nix/fish.nix { inherit pkgs; };
    neovim = import ../../nix/neovim.nix { inherit pkgs; };
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
