# Services Guide

This document covers the services and infrastructure components managed on this NixOS system.

---

## Caddy Reverse Proxy

[Caddy](https://caddyserver.com) is a powerful, extensible web server and reverse proxy written in
Go. It features automatic HTTPS, simple configuration via the Caddyfile format, and excellent NixOS
integration.

### Basic NixOS Configuration

Enable Caddy in your NixOS configuration:

```nix
{ config, pkgs, ... }:
{
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

      "pihole.megaparsec.ca" = {
        extraConfig = ''
          reverse_proxy localhost:8081
        '';
      };
    };
  };
}
```

### Firewall Configuration

Use `openFirewall = true` to automatically open ports 80, 443 (TCP and UDP for HTTP/3). For manual
control:

```nix
networking.firewall.allowedTCPPorts = [ 80 443 ];
networking.firewall.allowedUDPPorts = [ 443 ];
```

### TLS Configuration

#### External (Public Internet)

For public-facing services, Caddy handles Let's Encrypt automatically. Just ensure:

1. DNS records point to your server (CNAMEs to apex domain work)
2. Ports 80 and 443 are open
3. Your email is set via `services.caddy.email`

```caddyfile
rss.megaparsec.ca
reverse_proxy localhost:8080
```

Caddy will automatically obtain and renew the certificate.

#### Internal (Private LAN)

For internal-only services, you can use a custom CA (see [TLS Internal Guide](./tls-internal.md)):

```nix
services.caddy = {
  enable = true;

  virtualHosts."pihole.internal" = {
    extraConfig = ''
      tls /etc/ssl/internal/pihole.internal.pem /etc/ssl/internal/pihole.internal-key.pem
      reverse_proxy localhost:8081
    '';
  };
};
```

### Environment Variables

Caddy can read environment variables from a file for sensitive data like API tokens:

```nix
services.caddy = {
  enable = true;
  environmentFile = config.age.secrets.caddy-env.path;
};

age.secrets.caddy-env.file = ../../secrets/caddy-env.age;
```

The environment file should contain:

```
CLOUDFLARE_API_TOKEN=your-token-here
```

### Advanced Configuration

#### Headers and Security

Add security headers to your virtual hosts:

```nix
virtualHosts."rss.megaparsec.ca" = {
  extraConfig = ''
    reverse_proxy localhost:8080

    header {
      Strict-Transport-Security "max-age=31536000; includeSubDomains"
      X-Content-Type-Options "nosniff"
      X-Frame-Options "DENY"
      Referrer-Policy "strict-origin-when-cross-origin"
    }
  '';
};
```

#### WebSockets

Caddy handles WebSockets automatically with `reverse_proxy`, but you can be explicit:

```caddyfile
git.megaparsec.ca
reverse_proxy localhost:3000 {
    header_up X-Real-IP {remote_host}
    header_up X-Forwarded-For {remote_host}
    header_up X-Forwarded-Proto {scheme}
}
```

#### Multiple Backends / Load Balancing

```caddyfile
app.megaparsec.ca
reverse_proxy localhost:8080 localhost:8081
```

#### Unix Socket Proxy

```caddyfile
api.megaparsec.ca
reverse_proxy unix//run/my-service.sock
```

### Maintenance

#### Check Status

```bash
systemctl status caddy
journalctl -u caddy -f
```

#### Reload Configuration

```bash
systemctl reload caddy
```

#### View Certificates

```bash
# Caddy stores certificates in its data directory
ls -la /var/lib/caddy/.local/share/caddy/certificates/
```

### Troubleshooting

- **Certificate failures**: Check DNS resolution and port 80/443 accessibility
- **Permission errors**: Ensure Caddy can read certificate/key files
- **Backend unreachable**: Verify the service is running and listening on the expected port

---

## Links

- [DNS Setup](./dns.md) - Cloudflare DDNS and DNS configuration
- [External TLS Guide](./tls-external.md) - Let's Encrypt for public services
- [Internal TLS Guide](./tls-internal.md) - Custom CA for internal services
- [Caddy Official Documentation](https://caddyserver.com/docs/)
- [Caddyfile Reference](https://caddyserver.com/docs/caddyfile)
- [NixOS Caddy Module](https://wiki.nixos.org/wiki/Caddy)
- [Caddy DNS Plugins](https://caddyserver.com/docs/modules/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
