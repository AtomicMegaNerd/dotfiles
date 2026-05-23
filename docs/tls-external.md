# External TLS Guide (Public Internet)

This guide covers setting up trusted TLS certificates for public-facing services (e.g.,
`rss.megaparsec.ca`) using **Let's Encrypt** via the **ACME protocol**.

---

## DNS Configuration

Ensure your subdomains resolve to your public IP.

Create CNAME records in Cloudflare pointing to your apex domain. Since `cloudflare-ddns` updates the
A/AAAA records for `megaparsec.ca`, all CNAMEs will automatically resolve to the correct IP without
needing to modify the DDNS config.

| Type  | Name | Value         |
| ----- | ---- | ------------- |
| CNAME | rss  | megaparsec.ca |
| CNAME | git  | megaparsec.ca |
| CNAME | www  | megaparsec.ca |

---

## Caddy Configuration

Caddy handles Let's Encrypt automatically. No separate ACME module is needed.

### NixOS Configuration

Enable Caddy in your NixOS configuration:

```nix
services.caddy = {
  enable = true;
  email = "your-email@megaparsec.ca";
  openFirewall = true;

  virtualHosts = {
    "rss.megaparsec.ca" = {
      extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };

    "git.megaparsec.ca" = {
      extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
  };
};
```

Caddy will automatically obtain and renew certificates for any domain listed in `virtualHosts`.

---

## Certificate Management

Certificates are automatically managed by Caddy.

- **Location:** `/var/lib/caddy/.local/share/caddy/certificates/`
- **Renewal:** Handled automatically by Caddy's internal ACME client

**Note:** Caddy runs as the `caddy` user and manages certificate permissions internally.

---

## Firewall Configuration

Use `services.caddy.openFirewall = true` in your NixOS config to automatically open ports 80, 443
(TCP and UDP for HTTP/3).

If you prefer manual control:

```nix
networking.firewall.allowedTCPPorts = [
  80   # Required for HTTP-01 ACME challenge
  443  # Required for HTTPS traffic
];
networking.firewall.allowedUDPPorts = [
  443  # Required for HTTP/3 (QUIC)
];
```

---

## Security Considerations

- **Rate Limits:** Let's Encrypt has rate limits. Test with `staging` endpoints if configuring for
  the first time to avoid hitting limits.

---

## Maintenance

- **Auto-Renewal:** Caddy handles certificate renewal automatically.

- **Monitoring:** Check Caddy logs for renewal status:

  ```bash
  journalctl -u caddy -f
  ```

- **Reload:** Apply configuration changes without downtime:

  ```bash
  systemctl reload caddy
  ```

---

## Links

- [DNS Setup](./dns.md) - Cloudflare DDNS and DNS configuration
- [Services Guide](./services.md) - Caddy reverse proxy configuration
- [Internal TLS Guide](./tls-internal.md) - Custom CA for internal services
- [Caddy Official Documentation](https://caddyserver.com/docs/)
- [Caddy TLS Documentation](https://caddyserver.com/docs/caddyfile/directives/tls)
- [NixOS Caddy Module](https://wiki.nixos.org/wiki/Caddy)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [Cloudflare DNS Management](https://developers.cloudflare.com/dns/)
- [cloudflare-ddns GitHub Repository](https://github.com/favonia/cloudflare-ddns)
