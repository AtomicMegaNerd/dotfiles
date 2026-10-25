# Actual Budget

[Actual Budget](https://actualbudget.org/) runs as a Podman container on Blahaj at `https://budget.megaparsec.ca`. We will use plain passord authentication.

## Pre-Requsites

- DNS records for `budget.megaparsec.ca` added to DNS (see [dns.md](./dns.md)).
- TLS cert generated for `budget.megaparsec.ca` (see [tls-internal.md](./tls-internal.md)).

## Blahaj configuration

Configured in `hosts/blahaj/actualbudget.nix`.

```nix
{ pkgs, ... }:
let
  actualBudgetVersion = "26.10.0";
  actualBudgetUid = 890;
  actualBudgetGid = 890;
  backupScript = pkgs.writeShellScriptBin "backup-actualbudget" ''
    set -euo pipefail
    ${pkgs.rsync}/bin/rsync -a --delete /var/lib/actualbudget/ /data/backups/actualbudget/
  '';
in
{
  users.groups.actualbudget = {
    gid = actualBudgetGid;
  };
  users.users.actualbudget = {
    uid = actualBudgetUid;
    group = "actualbudget";
    isSystemUser = true;
  };

  virtualisation.oci-containers.containers.actualbudget = {
    autoStart = true;
    image = "actualbudget/actual-server:${actualBudgetVersion}";
    volumes = [ "/var/lib/actualbudget:/data" ];
    environment = {
      TZ = "America/Edmonton";
      ACTUAL_ALLOWED_LOGIN_METHODS = "password";
    };
    extraOptions = [
      "--network=podman-ipv6"
      "--ip6=fd00::13"
      "--user=${toString actualBudgetUid}:${toString actualBudgetGid}"
    ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-actualbudget.service" ];
    before = [ "podman-actualbudget.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/actualbudget 0750 actualbudget actualbudget -"
    "d /data/backups/actualbudget 0755 root root -"
  ];

  systemd.timers.backup-actualbudget = {
    description = "Run backup of Actual Budget data daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.backup-actualbudget = {
    description = "Backup Actual Budget data to /data/backups";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/backup-actualbudget";
    };
  };
}
```

## Caddy

In `hosts/blahaj/caddy.nix`:

```caddy
budget.megaparsec.ca {
  tls /certs/internal-tls-cert /certs/internal-tls-key
  reverse_proxy [fd00::13]:5006
}
```

## Initial setup

```bash
nh os switch .
```

Open [https://budget.megaparsec.ca](https://budget.megaparsec.ca) and set the server password. Every device must trust `static/rcd-rootCA-pub.pem`. In the desktop app, enter the server URL and select mkcert's `rootCA.pem` (`mkcert -CAROOT`) if prompted.

## Backup and restore

`backup-actualbudget` rsyncs `/var/lib/actualbudget/` to `/data/backups/actualbudget/`; restore as described in [Services](./services.md#backups). For a portable copy use **More > Settings > Export Data**.

## Links

- [Actual Docker install](https://actualbudget.org/docs/install/docker)
- [Actual server configuration](https://actualbudget.org/docs/config/)
- [Actual HTTPS](https://actualbudget.org/docs/config/https)
- [Actual backups](https://actualbudget.org/docs/backup-restore/backup)
