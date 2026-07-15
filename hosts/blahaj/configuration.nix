{ pkgs, ... }:
let
  rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in
{
  imports = [
    ./hardware-configuration.nix

    # The following are services that we deploy on this host
    ./podman-network.nix
    ./pihole.nix
    ./freshrss.nix
    ./starfeed.nix
    ./cloudflare-ddns.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "blahaj";
    useDHCP = false;
    # We want to hardcode DNS servers because DHCP from our gateway uses THIS machine running
    # pihole for DNS. This is the one machine on the network that does not.
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp0s31f6";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config.UseDNS = false;
      ipv6AcceptRAConfig.UseDNS = false;
      linkConfig.RequiredForOnline = "routable";
    };
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.rcd = {
    isNormalUser = true;
    description = "Chris Dunphy";
    extraGroups = [
      "wheel"
      "podman"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  programs.fish.enable = true;
  programs.nix-ld.enable = true; # Allow running unpatched Linux binaries
  programs.neovim.enable = true;
  programs.starship.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    dig
    rsync
  ];

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.oci-containers.backend = "podman";

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "rcd" ];
      LoginGraceTime = "30s";
      MaxAuthTries = "3";
      X11Forwarding = false;
    };
  };

  # Nix Config
  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
}
