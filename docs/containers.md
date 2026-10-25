# Container Networking

We use podman as the container runtime.

## Podman Network

| Setting | Value                          |
| ------- | ------------------------------ |
| Name    | `podman-ipv6`                  |
| Subnet  | `fd00::/64`                    |
| Gateway | `fd00::1`                      |
| DNS     | Disabled (Pi-hole handles DNS) |

## Container Addresses

Static IPv6 addresses allow Caddy to reach backend containers directly without requiring container DNS resolution (which conflicts with Pi-hole on port 53). Beszel Hub additionally binds its port to host loopback for local-only access.

| Container  | IPv6 Address | Port Mappings                              |
| ---------- | ------------ | ------------------------------------------ |
| pihole     | `fd00::10`   | `53:53/tcp`, `53:53/udp`                   |
| freshrss   | `fd00::11`   | None                                       |
| beszel-hub | `fd00::12`   | `127.0.0.1:8090:8090/tcp` (localhost only) |
| caddy      | Dynamic      | `443:443/tcp`                              |
| starfeed   | Dynamic      | None                                       |

## Communication

Caddy reverse proxies to backend containers via IPv6:

- `pihole.megaparsec.ca` → `[fd00::10]:80`
- `freshrss.megaparsec.ca` → `[fd00::11]:80`
- `monitor.megaparsec.ca` → `[fd00::12]:8090` (Beszel Hub; WebSocket read timeout: 360s)

## Troubleshooting

```bash
# View logs for a container's systemd service
journalctl -u podman-starfeed.service

# Follow logs in real-time
journalctl -u podman-starfeed.service -f

# Show last N lines
journalctl -u podman-starfeed.service -n 50

# Filter by time
journalctl -u podman-starfeed.service --since "10 minutes ago"

# See all podman container logs
journalctl -u "podman-*"
```
