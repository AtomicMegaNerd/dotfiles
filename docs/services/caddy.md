# Caddy

[Caddy](https://caddyserver.com) is my reverse proxy. It runs as a podman container.

| Client DNS               | Service Endpoint                                             |
| ------------------------ | ------------------------------------------------------------ |
| `pihole.megaparsec.ca`   | `pihole:80`                                                  |
| `freshrss.megaparsec.ca` | `freshrss:80`                                                |
| `monitor.megaparsec.ca`  | `beszel-hub:8090` (Beszel Hub; WebSocket read timeout: 360s) |
| `budget.megaparsec.ca`   | `actualbudget:5006`                                          |
| `git.megaparsec.ca`      | `forgejo:3000`                                               |

## Configuration

See [caddy.nix](../../hosts/blahaj/caddy.nix).

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [Internal TLS](../infra/tls-internal.md) - Custom CA and certificates
- [DNS](../infra/dns.md) - DNS setup.
