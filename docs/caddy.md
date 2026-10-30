# Caddy

[Caddy](https://caddyserver.com) is used as a reverse proxy. It runs as a Podman container and terminates TLS for internal hostnames.

| Hostname                 | Upstream                                                     |
| ------------------------ | ------------------------------------------------------------ |
| `pihole.megaparsec.ca`   | `pihole:80`                                                  |
| `freshrss.megaparsec.ca` | `freshrss:80`                                                |
| `monitor.megaparsec.ca`  | `beszel-hub:8090` (Beszel Hub; WebSocket read timeout: 360s) |
| `budget.megaparsec.ca`   | `actualbudget:5006`                                          |
| `git.megaparsec.ca`      | `forgejo:3000`                                               |

Upstreams are container names, which Podman's DNS resolves on the shared default network.

## Configuration

See [caddy.nix](../hosts/blahaj/caddy.nix). To add a service, add a `site` line there. The certificate comes from [Internal TLS](./tls-internal.md).

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and DNS
- [Internal TLS Guide](./tls-internal.md) - Custom CA and certificates
- [Caddy Documentation](https://caddyserver.com/docs/)
