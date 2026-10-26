# FreshRSS

[FreshRSS](https://www.freshrss.org/) is the self-hosted RSS reader at [freshrss.megaparsec.ca](https://freshrss.megaparsec.ca). It runs as a Podman container.

## Prerequisites

- DNS and TLS for `freshrss.megaparsec.ca` (see [DNS](./dns.md) and [Internal TLS](./tls-internal.md)).

## Nix configuration

Configured in [freshrss.nix](../hosts/blahaj/freshrss.nix):

- **Address:** static, no published ports. See [Podman](./podman.md).
- **Route:** `freshrss.megaparsec.ca` through Caddy. See [Caddy](./caddy.md).
- **Feed refresh:** the built-in cron runs at minutes 15 and 45 (`CRON_MIN`), in the `America/Edmonton` time zone.
- **Data:** `/etc/freshrss/data` (config and the SQLite database) and `/etc/freshrss/extensions` are bind-mounted into the container.

## Initial setup

After applying the configuration open [freshrss.megaparsec.ca](https://freshrss.megaparsec.ca) and finish the installation in the web interface, which creates the admin user.

## Backup and restore

> [!IMPORTANT]
> I need to validate that this is correct and can be restored.

`backup-freshrss` rsyncs `/etc/freshrss/data/` to `/data/backups/freshrss/data/` and `/etc/freshrss/extensions/` to `/data/backups/freshrss/extensions/`.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and static IPv6 addresses
- [FreshRSS Docker install](https://github.com/FreshRSS/FreshRSS/blob/edge/Docker/README.md)
- [FreshRSS documentation](https://freshrss.github.io/FreshRSS/)
