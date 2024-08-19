{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "metropolitan-nixos-01";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  # User Account
  users.users.rcd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "podman" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  environment.systemPackages = (import ../../nix/packages.nix { inherit pkgs; })
    ++ (with pkgs; [ neovim starship git ]);

  services = {
    openssh = {
      permitRootLogin = "no";
      passwordAuthentication = false;
      enable = true;
    };
    qemuGuest.enable = true;
  };

  programs = { fish.enable = true; };

  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.05";
}

