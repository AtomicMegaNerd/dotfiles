{ pkgs, ... }:
let
  freshRssVersion = "1.30.4";
  backupScript = pkgs.writeShellScriptBin "backup-freshrss" ''
    set -euo pipefail
    ${pkgs.rsync}/bin/rsync -a --delete /etc/freshrss/data/ /data/backups/freshrss/data/
    ${pkgs.rsync}/bin/rsync -a --delete /etc/freshrss/extensions/ /data/backups/freshrss/extensions/
  '';
in
{
  virtualisation.oci-containers.containers.freshrss = {
    autoStart = true;
    image = "freshrss/freshrss:${freshRssVersion}";
    volumes = [
      "/etc/freshrss/data:/var/www/FreshRSS/data"
      "/etc/freshrss/extensions:/var/www/FreshRSS/extensions"
    ];
    environment = {
      TZ = "America/Edmonton";
      CRON_MIN = "15,45";
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/backups/freshrss 0755 root root -"
  ];

  systemd.timers.backup-freshrss = {
    description = "Run backup of FreshRSS data daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.backup-freshrss = {
    description = "Backup FreshRSS data to /data/backups";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/backup-freshrss";
    };
  };
}
