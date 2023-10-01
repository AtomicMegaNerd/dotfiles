# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{

  wsl = {
  enable = true;
  defaultUser = "rcd";
  wslConf = {
    network.hostname = "metropolitan";
    };
  };

  environment.systemPackages = with pkgs;
    [
      wget
      curl
      git
      neovim
      du-dust
      duf
      htop
      ripgrep
      fd
      exa
      grc
      zip
      unzip
      procs
      jq
      fish
      kubectl
    ];  
    environment.shellInit = ''export  NIXPATH="/nix/var/nix/profiles/per-user/$USER/channels:nixos-config=/etc/nixos/configuration.nix"'';

   users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul"
      ];
    };
  };

 nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.fish.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
