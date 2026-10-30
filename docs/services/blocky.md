# Blocky

[Blocky](https://0xerr0r.github.io/blocky/) is a pi-hole alternative that is lightweight and
is implemented in Go.

> [!NOTE]
> This has not been deployed yet

## Example NixOS Configuration

This needs to be verified and tested:

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
    image = "docker.io/spx01/blocky:${blockyVersion}";
    ports = map (protocol: "53:53/${protocol}") [
      "tcp"
      "udp"
    ];
    volumes = [ "${(pkgs.formats.yaml { }).generate "blocky.yml" settings}:/app/config.yml:ro" ];
  };
}
```

## Next Steps

- [ ] Add `blocky.nix` with a pinned image, port 53 published and the config mounted from Nix.
- [ ] Test next to Pi-hole on another port, then switch and remove Pi-hole.
- [ ] Remove the `pihole.megaparsec.ca` record, Caddy route and certificate entry, and update docs.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [DNS](../infra/dns.md)
- [Caddy](./caddy.md)
