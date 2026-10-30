# FreshRSS

[FreshRSS](https://www.freshrss.org/) is the self-hosted RSS reader at [freshrss.megaparsec.ca](https://freshrss.megaparsec.ca). It runs as a Podman container.

## Nix configuration

Configured in [freshrss.nix](../../hosts/blahaj/freshrss.nix):

## Initial setup

After applying the configuration open [freshrss.megaparsec.ca](https://freshrss.megaparsec.ca) and finish the installation in the web interface, which creates the admin user.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [Backups](../infra/backups.md) - Backup and restore
- [FreshRSS Docker install](https://github.com/FreshRSS/FreshRSS/blob/edge/Docker/README.md)
- [FreshRSS documentation](https://freshrss.github.io/FreshRSS/)
