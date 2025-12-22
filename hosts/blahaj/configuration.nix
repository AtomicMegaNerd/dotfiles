{ pkgs, ... }:
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
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      8080
      8081
      53
    ];
    firewall.allowedUDPPorts = [ 53 ];
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    interfaces.enp0s31f6.useDHCP = true;
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

  systemd.tmpfiles.rules = [
    "d /data/backups 0755 root root -"
    "d /data/backups/pihole 0755 root root -"
    "d /data/backups/freshrss 0755 root root -"
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
        image = "pihole/pihole:2025.11.1";
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
        image = "freshrss/freshrss:1.27.1";
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
        image = "atomicmeganerd/starfeed:v0.1.6";
        environmentFiles = [ "/etc/starfeed/.env" ];
        dependsOn = [ "freshrss" ];
        extraOptions = [
          "--network=podman-ipv6"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    starship
    git
    dig
    rsync
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = "no";
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = "no";
      AllowUsers = [ "rcd" ];
      LoginGraceTime = "30s";
      MaxAuthTries = "3";
    };
  };
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  systemd.services.backup-pihole-freshrss = {
    description = "Backup Pi-hole and FreshRSS data to /data/backups";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/backup-pihole-freshrss";
    };
  };

  systemd.timers.backup-pihole-freshrss = {
    description = "Run backup of Pi-hole and FreshRSS data daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.create-podman-network = {
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
