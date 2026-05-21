# AtomicMegaNerd's DNS Setup for megaparsec.ca

This reference information pertains to my DNS setup for my **megaparsec.ca** domain.

--

## Cloudflare

Even though [Hover](https://hover.com) is my domain registrar I host my domain on
[Cloudflare](https://dash.cloudflare.com/). To enable this I setup the following name servers on the
Hover side:

```text
adi.ns.cloudflare.com
brodie.ns.cloudflare.com
```

---

## Outlook.com Email

The following settings are used to connect my personal `megaparsec.ca` domain to
[outlook.com](https://outlook.com) for email.

| Type  | Host         | Value                           | TTL        |
| ----- | ------------ | ------------------------------- | ---------- |
| MX    | @            | 0 202129490.pamx1.hotmail.com   | 15 Minutes |
| TXT   | @            | v=spf1 include:outlook.com -all | 15 Minutes |
| CNAME | autodiscover | autodiscover.outlook.com        | 15 Minutes |

---

## Dynamic DNS - Cloudflare

I use [cloudflare-ddns](https://github.com/favonia/cloudflare-ddns) via the NixOS
`services.cloudflare-ddns` module to automatically update A and AAAA records for `megaparsec.ca`.
This runs alongside DuckDNS.

**NOTE:** There is no need to manually create A or AAAA records in Cloudflare first. The service
will automatically create them on first run if they don't already exist.

### Create a Cloudflare API Token

- Go to [Cloudflare API Tokens](https://dash.cloudflare.com/profile/api-tokens)
- Click **Create Token** → **Use template** → **Edit zone DNS**
- Under **Permissions**, ensure:
  - Zone → Zone → **Read**
  - Zone → DNS → **Edit**
- Under **Zone Resources**, select **Include** → **Specific zone** → `megaparsec.ca`
- Click **Continue to summary**, then **Create token**
- Copy the token and securely save it — you won't see it again

### Encrypt the Token with Agenix

Follow the steps [secrets.md](./secrets.md) to save the token securely in the the file
`secrets/cloudflare-ddns-token.age` in the flake. The contents are the environment variable
`CLOUDFLARE_API_TOKEN=<token>`.

### Nix Configuration

Add the following to the `blahaj` config:

```nix
age.secrets = {
  # other secrets...
  cloudflare-ddns-token.file = ../../secrets/cloudflare-ddns-token.age;
};

services.cloudflare-ddns = {
  enable = true;
  credentialsFile = config.age.secrets.cloudflare-ddns-token.path;
  domains = [ "megaparsec.ca" ];
  proxied = "false";
};

# Make sure it does not start before the network is ready
systemd.services.cloudflare-ddns = {
  after = [ "network-online.target" ];
  wants = [ "network-online.target" ];
};
```

Then run the os rebuilt:

```bash
nh os rebuild .
```

### Verification

Check the service status:

```bash
systemctl status cloudflare-ddns
journalctl -u cloudflare-ddns -f
```

Verify the DNS records in the [Cloudflare Dashboard](https://dash.cloudflare.com) → `megaparsec.ca`
→ **DNS** — you should see A and AAAA records updated to your current public IPs.

---

## Let's Encrypt

This section will discuss how to setup Let's Encrypt for TLS.

---

## Internal DNS (Pihole)

I have [pihole](https://pi-hole.net/) running as my internal DNS server.
