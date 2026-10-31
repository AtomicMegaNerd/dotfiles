{ config, pkgs, ... }:
let
  # Every container that keeps state on disk. Stopped during the backup so
  # that SQLite databases are copied in a consistent state.
  units = map (name: "podman-${name}.service") [
    "forgejo"
    "freshrss"
    "actualbudget"
    "beszel-agent"
    "beszel-hub"
  ];
  unitList = builtins.concatStringsSep " " units;
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  age.secrets.restic-password.file = ../../secrets/restic-password.age;

  services.restic.backups.local = {
    repository = "/data/backups/restic";
    passwordFile = config.age.secrets.restic-password.path;
    initialize = true;

    paths = [
      "/var/lib/forgejo"
      "/var/lib/actualbudget"
      "/var/lib/beszel"
      "/etc/freshrss"
    ];

    backupPrepareCommand = "${systemctl} stop ${unitList}";
    # Runs even when the backup fails
    backupCleanupCommand = "${systemctl} start ${unitList}";

    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  # Never write the repository onto the root disk if /data isn't mounted
  systemd.services.restic-backups-local.unitConfig.RequiresMountsFor = "/data";
}
