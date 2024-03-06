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

  networking = {
    hostName = "blahaj";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8443 8080 8081 53 ];
    firewall.allowedUDPPorts = [ 3478 53 ];
  };
        
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
  
  systemd.tmpfiles.rules = [
    "d /var/lib/unifi 0755 root root -"
    "d /etc/pihole 0755 root root -"
    "d /etc/dnsmasq.d 0755 root root -"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      unifi = {
        user = "unifi";
        autoStart = true;
        image = "jacobalberty/unifi:v8.0.28";
        ports = [ "8080:8080" "8443:8443" "3478:3478/udp" ];
        volumes = [ "/var/lib/unifi:/unifi" ];
        environment = {
          TZ = "America/Edmonton";
        };
        extraOptions = [
          "--network=host"
        ];
      };

      pihole = {
        user = "root";
        autoStart = true;
        image = "pihole/pihole:2024.02.2";
        ports = [ "53:53/tcp" "53:53/udp" "8081:80/tcp" ];
        volumes = [ "/etc/pihole:/etc/pihole" "/etc/dnsmasq.d:/etc/dnsmasq.d" ];
        environment = {
          TZ = "America/Edmonton";
        };
      };
    };
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
