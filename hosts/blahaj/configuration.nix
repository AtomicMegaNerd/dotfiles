# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  piholeUid = 888;
  piholeGid = 888;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking = {
    hostName = "blahaj";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8081 53 ];
    firewall.allowedUDPPorts = [ 53 ];
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    interfaces.enp0s31f6 = {
      useDHCP = true;
      ipv6.addresses = [{
        address = "fd00:1234:5678:9abc:def0:1234:5678:9abc";
        prefixLength = 64;
      }];
    };
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul"
      ];
    };
    groups.pihole = { gid = piholeGid; };
    users.pihole = {
      isSystemUser = true;
      uid = piholeUid;
      group = "pihole";
    };
  };

  systemd.tmpfiles.rules = [
    "Z /etc/pihole 0775 ${toString piholeUid} ${toString piholeGid} -"
    "Z /etc/dnsmasq.d 0775 ${toString piholeUid} ${toString piholeGid} -"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      pihole = {
        user = "root";
        autoStart = true;
        image = "pihole/pihole:2024.05.0";
        ports = [ "53:53/tcp" "53:53/udp" "8081:80/tcp" ];
        volumes = [ "/etc/pihole:/etc/pihole" "/etc/dnsmasq.d:/etc/dnsmasq.d" ];
        environment = {
          TZ = "America/Edmonton";
          FTLCONF_LOCAL_IPV4 = "192.168.1.232";
          FTLCONF_LOCAL_IPV6 = "fd00:1234:5678:9abc:def0:1234:5678:9abc";
          PIHOLE_UID = toString piholeUid;
          PIHOLE_GID = toString piholeGid;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch
    starship
    eza
    du-dust
    fish
    htop
    glow
    tldr
    wget
    curl
    duf
    ripgrep
    fd
    grc
    zip
    unzip
    procs
    jq
    nmap
    dig
    neovim
    git
    zoxide
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.fish.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
