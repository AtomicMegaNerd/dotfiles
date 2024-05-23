{ pkgs, ... }:
let
  rcd_pub_key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul";
in {
  home = {
    username = "rcd";
    homeDirectory = "/Users/rcd";
    stateVersion = "23.11";
    file.".ssh/allowed_signers".text = "${rcd_pub_key}";
  };

  home.packages = import ../../common/packages.nix { inherit pkgs; };
  programs.home-manager.enable = true;
  programs.fish = import ../../common/fish.nix { inherit pkgs; };
  programs.neovim = import ../../common/neovim.nix { inherit pkgs; };
  programs.tmux = import ../../common/tmux.nix { inherit pkgs; };
  programs.starship = import ../../common/starship.nix { inherit pkgs; };
  programs.zellij = import ../../common/zellij.nix { inherit pkgs; };

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

  programs.bat = {
    enable = true;
    config = { theme = "Nord"; };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
    nvim = {
      source = ../../common/nvim;
      target = "nvim";
    };
  };

  xdg.configFile = {
    alacritty = {
      source = ../../non-nix/Alacritty/Discovery;
      target = "alacritty";
    };
  };
}
