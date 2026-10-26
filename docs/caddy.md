# Caddy

[Caddy](https://caddyserver.com) is used as a reverse proxy. It runs as a Podman container and terminates TLS for internal hostnames.

| Hostname                 | Upstream                                                     |
| ------------------------ | ------------------------------------------------------------ |
| `pihole.megaparsec.ca`   | `[fd00::10]:80`                                              |
| `freshrss.megaparsec.ca` | `[fd00::11]:80`                                              |
| `monitor.megaparsec.ca`  | `[fd00::12]:8090` (Beszel Hub; WebSocket read timeout: 360s) |
| `budget.megaparsec.ca`   | `[fd00::13]:5006`                                            |
| `git.megaparsec.ca`      | `[fd00::14]:3000`                                            |

## Configuration

See [caddy.nix](../hosts/blahaj/caddy.nix).

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and static IPv6 addresses
- [Internal TLS Guide](./tls-internal.md) - Custom CA and certificates
- [Caddy Documentation](https://caddyserver.com/docs/)
