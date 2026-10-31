# Services

Services running on this homelab. See [Podman](../infra/podman.md) for networking and [Caddy](./caddy.md) for routes.

| Service         | Purpose                                                           | Hostname                                                         | Docs                                 | Config                                                     |
| --------------- | ----------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------ | ---------------------------------------------------------- |
| Blocky          | Internal DNS server and ad blocker                                | -                                                                | [dns.md](../infra/dns.md)            | [blocky.nix](../hosts/blahaj/blocky.nix)                   |
| FreshRSS        | RSS feed reader                                                   | [https://freshrss.megaparsec.ca](https://freshrss.megaparsec.ca) | [freshrss.md](./freshrss.md)         | [freshrss.nix](../hosts/blahaj/freshrss.nix)               |
| Starfeed        | Subscribes to RSS feeds for starred repos on different Git Forges | -                                                                | [starfeed.md](./starfeed.md)         | [starfeed.nix](../hosts/blahaj/starfeed.nix)               |
| Beszel          | Monitoring Hub and Agent                                          | [https://monitor.megaparsec.ca](https://monitor.megaparsec.ca)   | [beszel.md](./beszel.md)             | [beszel.nix](../hosts/blahaj/beszel.nix)                   |
| Actual Budget   | Personal budgeting app                                            | [https://budget.megaparsec.ca](https://budget.megaparsec.ca)     | [actualbudget.md](./actualbudget.md) | [actualbudget.nix](../hosts/blahaj/actualbudget.nix)       |
| Forgejo         | Internal Git forge                                                | [https://git.megaparsec.ca](https://git.megaparsec.ca)           | [forgejo.md](./forgejo.md)           | [forgejo.nix](../hosts/blahaj/forgejo.nix)                 |
| Forgejo runner  | Actions runner in a microVM                                       | -                                                                | [forgejo.md](./forgejo.md)           | [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix)   |
| Caddy           | Reverse proxy with internal TLS                                   | -                                                                | [caddy.md](./caddy.md)               | [caddy.nix](../hosts/blahaj/caddy.nix)                     |
| cloudflare-ddns | Keeps Cloudflare DNS records current                              | -                                                                | [dns.md](../infra/dns.md)            | [cloudflare-ddns.nix](../hosts/blahaj/cloudflare-ddns.nix) |

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [Backups](../infra/backups.md) - Backup and restore
