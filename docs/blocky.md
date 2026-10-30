# Blocky

[Blocky](https://0xerr0r.github.io/blocky/) will replace Pi-hole as the internal DNS server and ad blocker. It runs as a Podman container on blahaj with its config generated from Nix, so it holds no state and a second host can run the same config.

> [!NOTE]
> It's bed-time. Nothing is deployed yet. Pick up from the Todo list below.

## Example

A sketch for `blocky.nix`, not deployed. The records replace [dnsmasq.conf](../static/blahaj/dnsmasq.conf). A mapped name also resolves its subdomains.

```nix
{ config, lib, pkgs, ... }:
let
  blockyVersion = "v0.35.0";
  domain = "megaparsec.ca";
  blahaj = "192.168.1.232,2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4";

  hosts = {
    inherit blahaj;
    schooner = "192.168.1.238,2604:3d09:676:2d40:85b:b73e:966d:2c53";
    gateway = "192.168.1.1,2604:3d09:676:2d40::1";
    freshrss = blahaj;
    git = blahaj;
    monitor = blahaj;
    budget = blahaj;
  };

  settings = {
    ports.dns = 53;
    # Same dual stack upstreams the host uses
    upstreams.groups.default = config.networking.nameservers;
    # Each short name and its FQDN get the same addresses
    customDNS.mapping = lib.concatMapAttrs (name: addresses: {
      ${name} = addresses;
      "${name}.${domain}" = addresses;
    }) hosts;
    blocking = {
      denylists.ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
      clientGroupsBlock.default = [ "ads" ];
    };
  };
in
{
  virtualisation.oci-containers.containers.blocky = {
    autoStart = true;
    image = "ghcr.io/0xerr0r/blocky:${blockyVersion}";
    ports = map (protocol: "53:53/${protocol}") [
      "tcp"
      "udp"
    ];
    volumes = [ "${(pkgs.formats.yaml { }).generate "blocky.yml" settings}:/app/config.yml:ro" ];
  };
}
```

## Todo

- [ ] Add `blocky.nix` with a pinned image, port 53 published and the config mounted from Nix.
- [ ] Move the records in [dnsmasq.conf](../static/blahaj/dnsmasq.conf) to `customDNS.mapping`.
- [ ] Set the Quad9 IPv4 and IPv6 upstreams.
- [ ] Check that subdomains of a mapped name resolve the way they did with dnsmasq.
- [ ] Test next to Pi-hole on another port, then switch and remove Pi-hole.
- [ ] Remove the `pihole.megaparsec.ca` record, Caddy route and certificate entry, and update [dns.md](./dns.md), [services.md](./services.md), [caddy.md](./caddy.md) and [backups.md](./backups.md).

## Links

- [Blocky documentation](https://0xerr0r.github.io/blocky/)
- [DNS](./dns.md)
