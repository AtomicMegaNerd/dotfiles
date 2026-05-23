# Internal TLS Guide (Private LAN)

This guide covers setting up trusted TLS certificates for internal services (e.g., Pi-hole,
FreshRSS) accessible only on your local network (`192.168.1.0/24`).

---

## Create the Root CA

Run this on your primary management machine.

```bash
# Install mkcert
nix-shell -p mkcert  # or brew install mkcert on macOS

# Create the Root CA and install it locally
mkcert -install
```

This creates the Root CA files and adds the certificate to the **local machine's** trust store.

- **Location:** `$(mkcert -CAROOT)`
- **Files:** `rootCA.pem` (public cert) and `rootCA-key.pem` (private key).

---

## Distribute the Root CA via Nix

Copy `rootCA.pem` to `static/` in your dotfiles repo. Then use Nix to install it on both machines
automatically.

### On macOS (Schooner)

Add to `hosts/Schooner/darwin.nix`:

```nix
{ pkgs, ... }:
{
  security.pki.certificateFiles = [
    ../../static/rootCA.pem
  ];
}
```

Apply with:

```bash
nh darwin rebuild .
```

### On NixOS (blahaj)

Add to `hosts/blahaj/configuration.nix`:

```nix
{ pkgs, ... }:
{
  security.pki.certificateFiles = [
    ../../static/rootCA.pem
  ];
}
```

Apply with:

```bash
nh os rebuild .
```

---

## Generate Service Certificates

Generate certificates for your specific internal services. You can use IP addresses or internal
hostnames.

```bash
# Certificate for the server IP
mkcert 192.168.1.232

# Certificate for internal hostnames
mkcert blahaj schooner

# Certificate for wildcard
mkcert "*.megaparsec.ca"
```

**Output:** You will get a cert file (`*.pem`) and a key file (`*-key.pem`) for each. Store these
securely (e.g., `/etc/ssl/internal/`).

---

## Internal DNS Setup

For hostnames to work, your internal DNS (Pi-hole) must resolve them to your server IP.

### Pi-hole / Dnsmasq

Add custom DNS records via Nix-managed config files:

```nix
# In blahaj configuration
environment.etc."dnsmasq.d/internal-tls.conf".text = ''
  address=/blahaj/192.168.1.232
  address=/schooner/192.168.1.232
'';
```

---

## Caddy Reverse Proxy Integration

Configure Caddy to use the generated certificates for internal services.

### NixOS Configuration

Add to your `blahaj` configuration:

```nix
services.caddy = {
  enable = true;

  virtualHosts = {
    "pihole.internal" = {
      extraConfig = ''
        tls /etc/ssl/internal/pihole.internal.pem /etc/ssl/internal/pihole.internal-key.pem
        reverse_proxy localhost:8081
      '';
    };

    "rss.internal" = {
      extraConfig = ''
        tls /etc/ssl/internal/rss.internal.pem /etc/ssl/internal/rss.internal-key.pem
        reverse_proxy localhost:8080
      '';
    };
  };
};
```

### Example Concept

```text
Client (https://pihole.internal)
  -> Caddy (Port 443, uses pihole.internal.pem)
  -> Pi-hole (http://127.0.0.1:8081)
```

---

## Maintenance

- **Rotation:** `mkcert` certs are valid for a long time, but you should rotate them periodically.
- **New Devices:** When adding a new device to the network, add `rootCA.pem` to its Nix config or
  manually trust it.

---

## Links

- [DNS Setup](./dns.md) - Internal DNS and Pi-hole configuration
- [Services Guide](./services.md) - Caddy reverse proxy configuration
- [External TLS Guide](./tls-external.md) - Let's Encrypt for public services
- [mkcert GitHub Repository](https://github.com/FiloSottile/mkcert)
- [nix-darwin `security.pki` Manual](https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-security.pki.certificateFiles)
- [NixOS `security.pki` Manual](https://nixos.org/manual/nixos/stable/#opt-security.pki.certificateFiles)
- [Pi-hole FTL Configuration](https://docs.pi-hole.net/ftldns/configfile/)
