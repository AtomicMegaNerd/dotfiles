{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../common/rcd_pub_key;
in {
  wsl = {
    enable = true;
    defaultUser = "rcd";
    wslConf = { network.hostname = "metropolitan"; };
  };

  users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [ rcd_pub_key ];
    };
  };

  environment.systempackages = with pkgs; [ neovim git ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.fish.enable = true;

  system.stateVersion = "23.11";
}

