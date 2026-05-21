{
  pkgs,
  config,
  ...
}:
let
  piholeUid = 888;
  piholeGid = 888;
  rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;

  backupScript = pkgs.writeShellScriptBin "backup-pihole-freshrss" ''
    ${pkgs.rsync}/bin/rsync -a --delete /etc/pihole/ /data/backups/pihole/
    ${pkgs.rsync}/bin/rsync -a --delete /etc/dnsmasq.d/ /data/backups/pihole/dnsmasq.d/
    ${pkgs.rsync}/bin/rsync -a --delete /etc/freshrss/data/ /data/backups/freshrss/data/
    ${pkgs.rsync}/bin/rsync -a --delete /etc/freshrss/extensions/ /data/backups/freshrss/extensions/
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "blahaj";
    useDHCP = false;
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    firewall.allowedTCPPorts = [
      8080
      8081
      53
    ];
    firewall.allowedUDPPorts = [ 53 ];
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
  programs.nix-ld.enable = true;
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

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      pihole = {
        autoStart = true;
        image = "pihole/pihole:2026.05.0";
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "8081:80/tcp"
        ];
        volumes = [
          "/etc/pihole:/etc/pihole"
          "/etc/dnsmasq.d:/etc/dnsmasq.d"
        ];
        environment = {
          TZ = "America/Edmonton";
          FTLCONF_LOCAL_IPV4 = "192.168.1.232";
          FTLCONF_LOCAL_IPV6 = "2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4";
          FTLCONF_dns_listeningMode = "all";
          PIHOLE_UID = toString piholeUid;
          PIHOLE_GID = toString piholeGid;
          BLOCK_ICLOUD_PR = "false";
        };
        extraOptions = [
          "--network=podman-ipv6"
        ];
      };

      freshrss = {
        autoStart = true;
        image = "freshrss/freshrss:1.29.1";
        ports = [
          "8080:80/tcp"
        ];
        volumes = [
          "/etc/freshrss/data:/var/www/FreshRSS/data"
          "/etc/freshrss/extensions:/var/www/FreshRSS/extensions"
        ];
        environment = {
          TZ = "America/Edmonton";
          CRON_MIN = "15,45";
        };
        extraOptions = [
          "--network=podman-ipv6"
        ];
      };

      starfeed = {
        autoStart = true;
        image = "atomicmeganerd/starfeed:0.4.1";
        environmentFiles = [ config.age.secrets.starfeed-env.path ];
        dependsOn = [ "freshrss" ];
        extraOptions = [
          "--network=podman-ipv6"
        ];
      };
    };
  };

  age.secrets = {
    starfeed-env.file = ../../secrets/starfeed-env.age;
    cloudflare-ddns-token.file = ../../secrets/cloudflare-ddns-token.age;
  };

  # Services Config
  services = {

    resolved.enable = false;

    openssh = {
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

    cloudflare-ddns = {
      enable = true;
      credentialsFile = config.age.secrets.cloudflare-ddns-token.path;
      domains = [ "megaparsec.ca" ];
      proxied = "false";
    };
  };

  # Systemd Config
  systemd = {

    tmpfiles.rules = [
      "d /data/backups 0755 root root -"
      "d /data/backups/pihole 0755 root root -"
      "d /data/backups/freshrss 0755 root root -"
    ];

    timers.backup-pihole-freshrss = {
      description = "Run backup of Pi-hole and FreshRSS data daily";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    services = {

      cloudflare-ddns = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };

      backup-pihole-freshrss = {
        description = "Backup Pi-hole and FreshRSS data to /data/backups";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${backupScript}/bin/backup-pihole-freshrss";
        };
      };

      create-podman-network = {
        serviceConfig.Type = "oneshot";
        wantedBy = [
          "podman-pihole.service"
          "podman-freshrss.service"
          "podman-starfeed.service"
        ];
        before = [
          "podman-pihole.service"
          "podman-freshrss.service"
          "podman-starfeed.service"
        ];
        script = ''
          # Create IPv6 network
          ${pkgs.podman}/bin/podman network exists podman-ipv6 || \
            ${pkgs.podman}/bin/podman network create \
              --driver=bridge \
              --ipv6 \
              --disable-dns \
              --subnet=fd00::/64 \
              --gateway=fd00::1 \
              podman-ipv6
        '';
      };
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
