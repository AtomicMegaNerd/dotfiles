# Actual Budget

[Actual Budget](https://actualbudget.org/) runs as a Podman container at [budget.megaparsec.ca](https://budget.megaparsec.ca).

## NixOS Server Configuration

Configured in [actualbudget.nix](../hosts/blahaj/actualbudget.nix).

## Initial setup

After applying the configuration open [https://budget.megaparsec.ca](https://budget.megaparsec.ca) and set the server password. Every device must trust `static/rcd-rootCA-pub.pem`.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [Backups](../infra/backups.md) - Backup and restore
- [Actual Docker install](https://actualbudget.org/docs/install/docker)
- [Actual server configuration](https://actualbudget.org/docs/config/)
- [Actual HTTPS](https://actualbudget.org/docs/config/https)
- [Actual backups](https://actualbudget.org/docs/backup-restore/backup)
