{ pkgs, ... }:
let
  piholeUid = 888;
  piholeVersion = "2026.10.0";
  piholeGid = 888;
  backupScript = pkgs.writeShellScriptBin "backup-pihole" ''
    set -euo pipefail
    ${pkgs.rsync}/bin/rsync -a --delete /etc/pihole/ /data/backups/pihole/
  '';

  # Internal DNS records passed to Pi-hole via FTLCONF_misc_dnsmasq_lines.
  # This avoids needing a /etc/dnsmasq.d volume mount (not needed for Pi-hole v6).
  blahajIpv4 = "192.168.1.232";
  blahajIpv6 = "2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4";
  schoonerIpv4 = "192.168.1.238";
  schoonerIpv6 = "2604:3d09:676:2d40:85b:b73e:966d:2c53";

  dnsmasqLines = [
    # Blahaj (NixOS server)
    "address=/blahaj/${blahajIpv4}"
    "address=/blahaj.megaparsec.ca/${blahajIpv4}"
    "address=/blahaj/${blahajIpv6}"
    "address=/blahaj.megaparsec.ca/${blahajIpv6}"
    # Schooner (macOS)
    "address=/schooner/${schoonerIpv4}"
    "address=/schooner.megaparsec.ca/${schoonerIpv4}"
    "address=/schooner/${schoonerIpv6}"
    "address=/schooner.megaparsec.ca/${schoonerIpv6}"
    # Gateway (UCG)
    "address=/gateway/192.168.1.1"
    "address=/gateway.megaparsec.ca/192.168.1.1"
    "address=/gateway/2604:3d09:676:2d40::1"
    "address=/gateway.megaparsec.ca/2604:3d09:676:2d40::1"
    # Services (all on blahaj)
    "address=/freshrss/${blahajIpv4}"
    "address=/freshrss.megaparsec.ca/${blahajIpv4}"
    "address=/freshrss/${blahajIpv6}"
    "address=/freshrss.megaparsec.ca/${blahajIpv6}"
    "address=/pihole/${blahajIpv4}"
    "address=/pihole.megaparsec.ca/${blahajIpv4}"
    "address=/pihole/${blahajIpv6}"
    "address=/pihole.megaparsec.ca/${blahajIpv6}"
    "address=/starfeed/${blahajIpv4}"
    "address=/starfeed.megaparsec.ca/${blahajIpv4}"
    "address=/starfeed/${blahajIpv6}"
    "address=/starfeed.megaparsec.ca/${blahajIpv6}"
  ];
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
    image = "pihole/pihole:${piholeVersion}";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "8081:80/tcp"
    ];
    volumes = [
      "/etc/pihole:/etc/pihole"
    ];
    environment = {
      TZ = "America/Edmonton";
      FTLCONF_LOCAL_IPV4 = blahajIpv4;
      FTLCONF_LOCAL_IPV6 = blahajIpv6;
      FTLCONF_dns_listeningMode = "all";
      FTLCONF_misc_dnsmasq_lines = builtins.concatStringsSep ";" dnsmasqLines;
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
