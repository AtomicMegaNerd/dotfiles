# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ pkgs, ... }:
let
  rcd_pub_key = builtins.readFile ../../common/rcd_pub_key;
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

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };
  
  system.stateVersion = "23.11";
}
