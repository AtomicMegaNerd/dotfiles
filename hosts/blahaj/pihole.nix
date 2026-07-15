{ pkgs, ... }:
let
  piholeUid = 888;
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

  # these are the ports that req required to be open for this service
  networking.firewall.allowedTCPPorts = [
    53
    8081
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:2026.07.2";
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
