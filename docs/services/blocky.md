# Blocky

[Blocky](https://0xerr0r.github.io/blocky/) is a pi-hole alternative that is lightweight and
is implemented in Go.

> [!NOTE]
> This has not been deployed yet.

## Example NixOS Configuration

The NixOS module is in [blocky.nix](../../hosts/blahaj/blocky.nix). It generates the configuration below and mounts it read-only into the container:

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

## Deployment checks

- [ ] Evaluate the NixOS configuration and validate the generated YAML with Blocky v0.35.0.
- [ ] Deploy and verify DNS responses for A and AAAA records, upstream resolution, and ad blocking.
- [ ] Regenerate the internal TLS certificate without the removed `pihole.megaparsec.ca` name and update the agenix secret.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [DNS](../infra/dns.md)
- [Caddy](./caddy.md)
