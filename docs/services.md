# Services

Services running on blahaj. See [Podman](./podman.md) for addresses and [Caddy](./caddy.md) for routes.

| Service         | Purpose                                                           | Hostname                                                         | Docs                                 | Config                                                     |
| --------------- | ----------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------ | ---------------------------------------------------------- |
| Pi-hole         | Internal DNS server and ad blocker                                | [https://pihole.megaparsec.ca](https://pihole.megaparsec.ca)     | [dns.md](./dns.md)                   | [pihole.nix](../hosts/blahaj/pihole.nix)                   |
| FreshRSS        | RSS feed reader                                                   | [https://freshrss.megaparsec.ca](https://freshrss.megaparsec.ca) | [freshrss.md](./freshrss.md)         | [freshrss.nix](../hosts/blahaj/freshrss.nix)               |
| Starfeed        | Subscribes to RSS feeds for starred repos on different Git Forges | -                                                                | [starfeed.md](./starfeed.md)         | [starfeed.nix](../hosts/blahaj/starfeed.nix)               |
| Beszel          | Monitoring Hub and Agent                                          | [https://monitor.megaparsec.ca](https://monitor.megaparsec.ca)   | [beszel.md](./beszel.md)             | [beszel.nix](../hosts/blahaj/beszel.nix)                   |
| Actual Budget   | Personal budgeting app                                            | [https://budget.megaparsec.ca](https://budget.megaparsec.ca)     | [actualbudget.md](./actualbudget.md) | [actualbudget.nix](../hosts/blahaj/actualbudget.nix)       |
| Caddy           | Reverse proxy with internal TLS                                   | -                                                                | [caddy.md](./caddy.md)               | [caddy.nix](../hosts/blahaj/caddy.nix)                     |
| cloudflare-ddns | Keeps Cloudflare DNS records current                              | -                                                                | [dns.md](./dns.md)                   | [cloudflare-ddns.nix](../hosts/blahaj/cloudflare-ddns.nix) |

## Implementation Information

### Backups

Pi-hole, FreshRSS and Actual Budget each have a daily `backup-<service>` timer that rsyncs their data to `/data/backups/<service>/`. Run one now with `sudo systemctl start backup-<service>`. To restore, stop `podman-<service>`, run `sudo rsync -a --delete` from the backup back into the data directory, and start the unit again.
