# Starfeed

[Starfeed](https://github.com/AtomicMegaNerd/starfeed) reads the repos you have starred on GitHub and Forgejo-based forges (such as Codeberg), and subscribes [FreshRSS](./freshrss.md) to each repo's releases feed.

## Pre-Requisites

- FreshRSS running, with an API token for its user (see [freshrss.md](./freshrss.md)).
- `secrets/starfeed-config.age` created with agenix (see [secrets.md](./secrets.md)).

## Blahaj configuration

Configured in [starfeed.nix](../hosts/blahaj/starfeed.nix).

- **Image:** `atomicmeganerd/starfeed`.
- **Network:** dynamic address, no published ports; it only makes outbound connections. See [Podman](./podman.md).
- **Start order:** `dependsOn = [ "freshrss" ]`, so it starts after FreshRSS.

## Configuration file

Starfeed reads a TOML file whose path is set by `STARFEED_CONFIG_PATH` (`/app/starfeed.toml`). It holds:

- run settings: `debug`, `single_run` and `run_interval` (1 to 168 hours)
- one `[[git_forges]]` entry per forge, with `type` (`github` or `forgejo`), `name`, `fqdn` and an API token that can read starred repos
- an `[rss_server]` entry for FreshRSS, with `url`, `user` and an API token that can create, edit and delete feeds

Because it contains tokens, the file is an agenix secret, `secrets/starfeed-config.age`. Edit it with `agenix -e` as described in [Secrets](./secrets.md).

The container is distroless and runs as uid 65532. The module declares a `starfeed` system user with that uid and makes it the owner of the decrypted file (mode `0400`), which is mounted read-only at `/app/starfeed.toml`.

`rss_server.url` uses FreshRSS's static address from [Podman](./podman.md), on port 80.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and static IPv6 addresses
- [Starfeed](https://github.com/AtomicMegaNerd/starfeed) - The GitHub repo
- [FreshRSS](./freshrss.md) - The RSS service we use with Starfeed
