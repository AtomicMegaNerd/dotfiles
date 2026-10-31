{
  config,
  lib,
  pkgs,
  ...
}:
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
    # Each short name and its FQDN get the same addresses.
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
  # resolved would conflict with Blocky's listener on port 53.
  services.resolved.enable = false;

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
