{ config, pkgs, ... }:
let
  # These are the services we need to take down briefly during the backup. Starfeed doesn't need
  # backup but it depends on freshrss, so it has to come down.
  services = builtins.concatStringsSep " " (
    map (name: "podman-${name}.service") [
      "forgejo"
      "freshrss"
      "starfeed"
      "actualbudget"
      "beszel-agent"
      "beszel-hub"
    ]
  );
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

    # These commands will run before and after the backup is performed
    backupPrepareCommand = "${systemctl} stop ${services}";
    backupCleanupCommand = "${systemctl} start ${services}";

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
