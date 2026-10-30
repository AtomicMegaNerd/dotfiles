{
  config,
  lib,
  pkgs,
  ...
}:
let
  piholeUid = 888;
  piholeVersion = "2026.10.0";
  piholeGid = 888;
  backupScript = pkgs.writeShellScriptBin "backup-pihole" ''
    set -euo pipefail
    ${pkgs.rsync}/bin/rsync -a --delete /etc/pihole/ /data/backups/pihole/
  '';
in
{
  # resolved is a DNS server that will conflict with pihole so we turn it off.
  services.resolved.enable = false;

  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:${piholeVersion}";
    ports = map (protocol: "53:53/${protocol}") [
      "tcp"
      "udp"
    ];
    volumes = [
      "/etc/pihole:/etc/pihole"
      "${../../static/blahaj/dnsmasq.conf}:/etc/dnsmasq.d/dnsmasq.conf:ro"
    ];
    environment = {
      TZ = "America/Edmonton";
      FTLCONF_LOCAL_IPV4 = "192.168.1.232";
      FTLCONF_LOCAL_IPV6 = "2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4";
      # Same dual stack upstreams the host uses
      FTLCONF_dns_upstreams = lib.concatStringsSep ";" config.networking.nameservers;
      FTLCONF_dns_listeningMode = "all";
      FTLCONF_misc_etc_dnsmasq_d = "true";
      PIHOLE_UID = toString piholeUid;
      PIHOLE_GID = toString piholeGid;
      BLOCK_ICLOUD_PR = "false";
    };
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
