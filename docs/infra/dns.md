# megaparsec.ca DNS

This documents the implementation of DNS on my network for the `megaparsec.ca` domain.

## Internal DNS

[Pi-hole](https://pi-hole.net/) runs on `blahaj` (`192.168.1.232`) as the internal DNS server.

### Configuration

DNS records are stored in a static config file at [dnsmasq.conf](../static/blahaj/dnsmasq.conf). The container is configured with `FTLCONF_misc_etc_dnsmasq_d = "true"` to enable reading from `/etc/dnsmasq.d`.

### Internal DNS records

| Host                                  | IPv4            | IPv6                                     | Purpose          |
| ------------------------------------- | --------------- | ---------------------------------------- | ---------------- |
| `blahaj` / `blahaj.megaparsec.ca`     | `192.168.1.232` | `2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4` | NixOS server     |
| `schooner` / `schooner.megaparsec.ca` | `192.168.1.238` | `2604:3d09:676:2d40:85b:b73e:966d:2c53`  | macOS            |
| `gateway` / `gateway.megaparsec.ca`   | `192.168.1.1`   | `2604:3d09:676:2d40::1`                  | UCG router       |
| `budget` / `budget.megaparsec.ca`     | `192.168.1.232` | `2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4` | Actual Budget    |
| `freshrss` / `freshrss.megaparsec.ca` | `192.168.1.232` | `2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4` | FreshRSS service |
| `git` / `git.megaparsec.ca`           | `192.168.1.232` | `2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4` | Git service      |
| `monitor` / `monitor.megaparsec.ca`   | `192.168.1.232` | `2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4` | Beszel Hub       |
| `pihole` / `pihole.megaparsec.ca`     | `192.168.1.232` | `2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4` | Pi-hole admin    |

### Testing DNS

```bash
# Test against Pi-hole via IPv4
dig @192.168.1.232 blahaj.megaparsec.ca A

# Test against Pi-hole via IPv6
dig @2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4 blahaj.megaparsec.ca AAAA

# Test IPv6 connectivity to hosts
ping6 blahaj.megaparsec.ca
ping6 gateway.megaparsec.ca

# Check if Pi-hole is running
ssh blahaj "systemctl status podman-pihole"
```

## Cloudflare

### Name servers

Even though [Hover](https://hover.com) is my domain registrar I host my domain on [Cloudflare](https://dash.cloudflare.com/). To enable this I setup the following name servers on the Hover side:

```text
adi.ns.cloudflare.com
brodie.ns.cloudflare.com
```

### Cloudflare dynamic DNS

I use [cloudflare-ddns](https://github.com/favonia/cloudflare-ddns) via the NixOS `services.cloudflare-ddns` module to automatically update A and AAAA records for `megaparsec.ca`.

> [!NOTE]
> There is no need to manually create A or AAAA records in Cloudflare first. The service will automatically create them on first run if they don't already exist.

#### Create a Cloudflare API token

- Go to [Cloudflare API Tokens](https://dash.cloudflare.com/profile/api-tokens)
- Click **Create Token** → **Use template** → **Edit zone DNS**
- Under **Permissions**, ensure:
  - Zone → Zone → **Read**
  - Zone → DNS → **Edit**
- Under **Zone Resources**, select **Include** → **Specific zone** → `megaparsec.ca`
- Click **Continue to summary**, then **Create token**
- Copy the token and securely save it — you won't see it again

#### Encrypt the token with Agenix

Follow the steps in [Secrets](./secrets.md) to save the token in `secrets/cloudflare-ddns-token.age`. The file contents are the environment variable `CLOUDFLARE_API_TOKEN=<token>`.

#### Nix configuration

The service is configured in [cloudflare-ddns.nix](../hosts/blahaj/cloudflare-ddns.nix). It reads the token from the secret and waits for `network-online.target` before it starts. Apply the configuration.

#### Verification

Check the service status:

```bash
systemctl status cloudflare-ddns
journalctl -u cloudflare-ddns -f
```

Verify the DNS records in the [Cloudflare Dashboard](https://dash.cloudflare.com) → `megaparsec.ca` → **DNS** — you should see A and AAAA records updated to your current public IPs.

## Outlook.com email

The following settings are used to connect my personal `megaparsec.ca` domain to [outlook.com](https://outlook.com) for email.

| Type  | Host         | Value                           | TTL        |
| ----- | ------------ | ------------------------------- | ---------- |
| MX    | @            | 0 202129490.pamx1.hotmail.com   | 15 Minutes |
| TXT   | @            | v=spf1 include:outlook.com -all | 15 Minutes |
| CNAME | autodiscover | autodiscover.outlook.com        | 15 Minutes |

## Links

- [Internal TLS Guide](./tls-internal.md) - Custom CA with Caddy for internal services
- [Services](../services/services.md) - Overview of services running on blahaj
