{ pkgs, ... }:
let
  piholeUid = 888;
  piholeVersion = "2026.10.0";
  piholeGid = 888;
  backupScript = pkgs.writeShellScriptBin "backup-pihole" ''
    set -euo pipefail
    ${pkgs.rsync}/bin/rsync -a --delete /etc/pihole/ /data/backups/pihole/
    ${pkgs.rsync}/bin/rsync -a --delete /etc/dnsmasq.d/ /data/backups/pihole/dnsmasq.d/
  '';
in
{

  # resolved is a DNS server that will conflict with pihole so we turn it off.
  services.resolved.enable = false;

  # Declarative internal DNS entries for local services and hosts
  environment.etc."dnsmasq.d/internal-dns.conf".text = ''
    # Blahaj (NixOS server)
    address=/blahaj/192.168.1.232
    address=/blahaj.megaparsec.ca/192.168.1.232
    address=/blahaj/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4
    address=/blahaj.megaparsec.ca/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4

    # Schooner (macOS)
    address=/schooner/192.168.1.238
    address=/schooner.megaparsec.ca/192.168.1.238
    address=/schooner/2604:3d09:676:2d40:85b:b73e:966d:2c53
    address=/schooner.megaparsec.ca/2604:3d09:676:2d40:85b:b73e:966d:2c53

    # Gateway (UCG)
    address=/gateway/192.168.1.1
    address=/gateway.megaparsec.ca/192.168.1.1
    address=/gateway/2604:3d09:676:2d40::1
    address=/gateway.megaparsec.ca/2604:3d09:676:2d40::1

    # Services (all on blahaj)
    address=/freshrss/192.168.1.232
    address=/freshrss.megaparsec.ca/192.168.1.232
    address=/freshrss/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4
    address=/freshrss.megaparsec.ca/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4

    address=/pihole/192.168.1.232
    address=/pihole.megaparsec.ca/192.168.1.232
    address=/pihole/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4
    address=/pihole.megaparsec.ca/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4

    address=/starfeed/192.168.1.232
    address=/starfeed.megaparsec.ca/192.168.1.232
    address=/starfeed/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4
    address=/starfeed.megaparsec.ca/2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4
  '';

  # these are the ports that req required to be open for this service
  networking.firewall.allowedTCPPorts = [
    53
    8081
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:${piholeVersion}";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "8081:80/tcp"
    ];
    volumes = [
      "/etc/pihole:/etc/pihole"
      "/etc/dnsmasq.d:/etc/dnsmasq.d"
      "/etc/static/dnsmasq.d:/etc/static/dnsmasq.d"
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

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-pihole.service" ];
    before = [ "podman-pihole.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /data/backups 0755 root root -"
    "d /data/backups/pihole 0755 root root -"
  ];

  systemd.timers.backup-pihole = {
    description = "Run backup of Pi-hole data daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.backup-pihole = {
    description = "Backup Pi-hole data to /data/backups";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/backup-pihole";
    };
  };
}
