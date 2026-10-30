# Starfeed

[Starfeed](https://github.com/AtomicMegaNerd/starfeed) have starred repos on compatible git forges and subscribes to each repo's release feed on [FreshRSS](./freshrss.md).

## Prerequisites

- FreshRSS running, with an API token for its user (see [freshrss.md](./freshrss.md)).
- `secrets/starfeed-config.age` created with agenix (see [secrets.md](../infra/secrets.md) and [Starfeed Config Docs](https://github.com/AtomicMegaNerd/starfeed#configuration)).

## NixOS configuration

Configured in [starfeed.nix](../hosts/blahaj/starfeed.nix).

Set `rss_server.url` to `http://freshrss:80`.

## Links

- [Starfeed](https://github.com/AtomicMegaNerd/starfeed) - The GitHub repo
- [FreshRSS](./freshrss.md) - The RSS service we use with Starfeed
- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
