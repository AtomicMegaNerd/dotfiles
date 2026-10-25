# Podman

We use podman as the container runtime.

## Podman Network

| Setting | Value                          |
| ------- | ------------------------------ |
| Name    | `podman-ipv6`                  |
| Subnet  | `fd00::/64`                    |
| Gateway | `fd00::1`                      |
| DNS     | Disabled (Pi-hole handles DNS) |

## Container Addresses

Static IPv6 addresses allow Caddy to reach backend containers directly without requiring container DNS resolution (which conflicts with Pi-hole on port 53).

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

## Container Health Checks

> [!NOTE]
> This is something I will look at afterwards.

The [Beszel](./beszel.md) Containers view reports `None` when Podman has no healthcheck configured; this does not mean the container is unhealthy. A running container or reported uptime also does not prove its application responds. A healthcheck can come from the image or be configured in the OCI container's `extraOptions` with `--health-cmd`, `--health-interval`, `--health-timeout`, and `--health-retries`. The health command must exist in the image and test the actual application.

See the Podman v5.8 [`podman run` healthcheck options](https://docs.podman.io/en/v5.8.0/markdown/podman-run.1.html) and [`podman healthcheck` management and run commands](https://docs.podman.io/en/v5.8.0/markdown/podman-healthcheck.1.html).

```bash
# Inspect the current health status
podman inspect --format '{{.State.Health.Status}}' <container>

# Run the configured healthcheck now
podman healthcheck run <container>
```

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
