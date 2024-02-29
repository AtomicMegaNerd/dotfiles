{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.hostName = "blahaj";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Edmonton";

  users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul"
      ];
    };
  };

  programs.fish.enable = true;
  services.openssh.enable = true;

  services.docker.networks = {
    default = {
      enable = true;
      bridge.enableIPForwarding = true;
    };
  };

  virtualisation.docker.enable = true;
  services.docker.containers = {
    {
      unifi = {
        enable = true;
        image = "jacobalberty/unifi";
        restart = "unless-stopped";
        ports = [
          "8080:8080"
          "8443:8443"
          "3478:3478/udp"
        ];
        environment = {
          TZ = "America/Edmonton";
        };
        volumes = [
          "${HOME}/unifi:/unifi"
        ];
        user = "unifi";
      };
    }
  };
      
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
