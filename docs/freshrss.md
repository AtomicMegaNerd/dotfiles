# FreshRSS

[FreshRSS](https://www.freshrss.org/) is the self-hosted RSS reader at [https://freshrss.megaparsec.ca](https://freshrss.megaparsec.ca). It runs as a Podman container on Blahaj and is the feed backend for [Starfeed](./starfeed.md).

## Prerequisites

- DNS records for `freshrss.megaparsec.ca` added to DNS (see [dns.md](./dns.md)).
- TLS cert generated for `freshrss.megaparsec.ca` (see [tls-internal.md](./tls-internal.md)).

## Blahaj configuration

Configured in [freshrss.nix](../hosts/blahaj/freshrss.nix).

- **Image:** `freshrss/freshrss`.
- **Address:** static, no published ports. See [Podman](./podman.md).
- **Route:** `freshrss.megaparsec.ca` through Caddy. See [Caddy](./caddy.md).
- **Feed refresh:** the built-in cron runs at minutes 15 and 45 (`CRON_MIN`), in the `America/Edmonton` time zone.
- **Data:** `/etc/freshrss/data` (config and the SQLite database) and `/etc/freshrss/extensions` are bind-mounted into the container.

## Initial setup

```bash
nh os switch .
```

Open [https://freshrss.megaparsec.ca](https://freshrss.megaparsec.ca) and finish the installation in the web interface, which creates the admin user. Starfeed needs an API token for that user.

## Backup and restore

`backup-freshrss` rsyncs `/etc/freshrss/data/` to `/data/backups/freshrss/data/` and `/etc/freshrss/extensions/` to `/data/backups/freshrss/extensions/`. Restore each directory as described in [Services](./services.md#backups).

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and static IPv6 addresses
- [FreshRSS Docker install](https://github.com/FreshRSS/FreshRSS/blob/edge/Docker/README.md)
- [FreshRSS documentation](https://freshrss.github.io/FreshRSS/)
