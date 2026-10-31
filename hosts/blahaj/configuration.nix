{ pkgs, ... }:
let
  rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;

  wan = "enp0s31f6";

  # Blocky publishes port 53, so Aardvark DNS listens on another port
  aardvarkPort = 5353;

  podmanNetwork = {
    ipv6_enabled = true;
    subnets = [
      {
        subnet = "10.88.0.0/16";
        gateway = "10.88.0.1";
      }
      {
        subnet = "fd00::/64";
        gateway = "fd00::1";
      }
    ];
  };

  microVmNet = {
    bridge = "vm-bridge";
    tapPrefix = "vm-tap-";
    v4 = rec {
      base = "10.77.0";
      prefixLength = 24;
      host = "${base}.1";
      hostCidr = "${host}/${toString prefixLength}";
      guestCidr = index: "${base}.${toString index}/${toString prefixLength}";
    };
    v6 = rec {
      base = "fd77::";
      prefixLength = 64;
      host = "${base}1";
      hostCidr = "${host}/${toString prefixLength}";
      guestCidr = index: "${base}${toString index}/${toString prefixLength}";
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../nix/nix-common.nix

    # The following are services that we deploy on this host
    ./blocky.nix
    ./freshrss.nix
    ./actualbudget.nix
    ./beszel.nix
    ./starfeed.nix
    ./cloudflare-ddns.nix
    ./caddy.nix
    ./forgejo.nix
    ./backup.nix
    (import ./forgejo-runner.nix { inherit podmanNetwork microVmNet; })
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "vhost_net" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "blahaj";
    useDHCP = false;
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = wan;
      internalInterfaces = [ microVmNet.bridge ];
    };
    # Containers must reach Aardvark DNS on the host
    firewall.interfaces.podman0 = {
      allowedUDPPorts = [ aardvarkPort ];
      allowedTCPPorts = [ aardvarkPort ];
    };
    # We want to hardcode DNS servers because DHCP from our gateway uses THIS machine running
    # Blocky for DNS. This is the one machine on the network that does not.
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
      matchConfig.Name = wan;
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config.UseDNS = false;
      ipv6AcceptRAConfig.UseDNS = false;
      linkConfig.RequiredForOnline = "routable";
    };

    netdevs."20-${microVmNet.bridge}".netdevConfig = {
      Kind = "bridge";
      Name = microVmNet.bridge;
    };

    networks."20-${microVmNet.bridge}" = {
      matchConfig.Name = microVmNet.bridge;
      address = [
        microVmNet.v4.hostCidr
        microVmNet.v6.hostCidr
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
      # The bridge has no carrier until a VM attaches
      linkConfig.RequiredForOnline = "no";
    };

    networks."21-microvm-taps" = {
      matchConfig.Name = "${microVmNet.tapPrefix}*";
      networkConfig.Bridge = microVmNet.bridge;
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
  virtualisation.containers.containersConf.settings.network.dns_bind_port = aardvarkPort;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings = podmanNetwork // {
      dns_enabled = true;
    };
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
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d --keep 3";
    };
  };

  security.pki.certificateFiles = [
    ../../static/rcd-rootCA-pub.pem
  ];

  system.stateVersion = "23.11";
}
