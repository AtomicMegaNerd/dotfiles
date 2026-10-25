# Actual Budget

[Actual Budget](https://actualbudget.org/) runs as a Podman container on Blahaj at `https://budget.megaparsec.ca`. We will use plain password authentication.

## Prerequisites

- DNS records for `budget.megaparsec.ca` added to DNS (see [dns.md](./dns.md)).
- TLS cert generated for `budget.megaparsec.ca` (see [tls-internal.md](./tls-internal.md)).

## Blahaj configuration

Configured in [actualbudget.nix](../hosts/blahaj/actualbudget.nix).

## Caddy

The route is listed in [Caddy](./caddy.md).

## Initial setup

```bash
nh os switch .
```

Open [https://budget.megaparsec.ca](https://budget.megaparsec.ca) and set the server password. Every device must trust `static/rcd-rootCA-pub.pem`. In the desktop app, enter the server URL and select mkcert's `rootCA.pem` (`mkcert -CAROOT`) if prompted.

## Backup and restore

For a portable backup, use **More > Settings > Export Data** and save the ZIP somewhere safe. To restore it, choose **Switch File > Import File > Actual** and select the ZIP.

## Links

- [Actual Docker install](https://actualbudget.org/docs/install/docker)
- [Actual server configuration](https://actualbudget.org/docs/config/)
- [Actual HTTPS](https://actualbudget.org/docs/config/https)
- [Actual backups](https://actualbudget.org/docs/backup-restore/backup)
