# Starfeed

[Starfeed](https://github.com/AtomicMegaNerd/starfeed) reads the repos you have starred on GitHub and Forgejo-based forges (such as Codeberg), and subscribes [FreshRSS](./freshrss.md) to each repo's releases feed.

## Prerequisites

- FreshRSS running, with an API token for its user (see [freshrss.md](./freshrss.md)).
- `secrets/starfeed-config.age` created with agenix (see [secrets.md](./secrets.md) and [Starfeed Config Docs](https://github.com/AtomicMegaNerd/starfeed#configuration)).

## NixOS configuration

Configured in [starfeed.nix](../hosts/blahaj/starfeed.nix).

## Notes

The container is distroless and runs as uid 65532. The module declares a `starfeed` system user with that uid and makes it the owner of the decrypted file (mode `0400`), which is mounted read-only at `/app/starfeed.toml`.

`rss_server.url` is `http://freshrss:80`. Podman's DNS resolves the container name (see [Podman](./podman.md)).

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and DNS
- [Starfeed](https://github.com/AtomicMegaNerd/starfeed) - The GitHub repo
- [FreshRSS](./freshrss.md) - The RSS service we use with Starfeed
