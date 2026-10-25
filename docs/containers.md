# Container Networking

## Podman Network

Static IPv6 addresses allow Caddy to reach backend containers directly without requiring container DNS resolution (which conflicts with Pi-hole on port 53) or host port mappings.

| Setting | Value                          |
| ------- | ------------------------------ |
| Name    | `podman-ipv6`                  |
| Subnet  | `fd00::/64`                    |
| Gateway | `fd00::1`                      |
| DNS     | Disabled (Pi-hole handles DNS) |

## Container Addresses

| Container | IPv6 Address | Port Mappings            |
| --------- | ------------ | ------------------------ |
| pihole    | `fd00::10`   | `53:53/tcp`, `53:53/udp` |
| freshrss  | `fd00::11`   | None                     |
| caddy     | Dynamic      | `443:443/tcp`            |
| starfeed  | Dynamic      | None                     |

## Communication

Caddy reverse proxies to backend containers via IPv6:

- `pihole.megaparsec.ca` → `[fd00::10]:80`
- `freshrss.megaparsec.ca` → `[fd00::11]:80`

Starfeed communicates with FreshRSS via container name on the podman network.
