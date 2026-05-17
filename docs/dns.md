# AtomicMegaNerd's DNS Setup for megaparsec.ca

This reference information pertains to my DNS setup for my **megaparsec.ca** domain.

--

## Cloudflare

Even though [Hover](https://hover.com) is my domain registrar I host my domain on Cloudflare. To
enable this I setup the following name servers on the Hover side:

```text
adi.ns.cloudflare.com
brodie.ns.cloudflare.com
```

### Outlook.com Email

The following settings are used to connect my personal `megaparsec.ca` domain to
[outlook.com](https://outlook.com) for email.

| Type  | Host         | Value                           | TTL        |
| ----- | ------------ | ------------------------------- | ---------- | -------- |
| MX    | @            | 0 202129490.pamx1.hotmail.com   | 15 Minutes |
| TXT   | @            | v=spf1 include:outlook.com -all | 15 Minutes |
| CNAME | autodiscover | autodiscover.outlook.com        | 15 Minutes | ## Email |

### Dynamic DNS

### Let's Encrypt

---

## Internal DNS (Pihole)

I have [pihole](https://pi-hole.net/) running as my internal DNS server.
