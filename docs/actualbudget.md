# Actual Budget

[Actual Budget](https://actualbudget.org/) runs as a Podman container at [budget.megaparsec.ca](https://budget.megaparsec.ca).

## Prerequisites

- DNS records setup (see [dns.md](./dns.md)).
- TLS cert generated and deployed (see [tls-internal.md](./tls-internal.md)).

## NixOS Server Configuration

Configured in [actualbudget.nix](../hosts/blahaj/actualbudget.nix).

## Caddy

The route is listed in [Caddy](./caddy.md).

## Initial setup

After applying the configuration open [https://budget.megaparsec.ca](https://budget.megaparsec.ca) and set the server password. Every device must trust `static/rcd-rootCA-pub.pem`.

## Links

- [Actual Docker install](https://actualbudget.org/docs/install/docker)
- [Actual server configuration](https://actualbudget.org/docs/config/)
- [Actual HTTPS](https://actualbudget.org/docs/config/https)
- [Actual backups](https://actualbudget.org/docs/backup-restore/backup)
