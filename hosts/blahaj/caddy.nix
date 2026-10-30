{ config, pkgs, ... }:
let
  caddyVersion = "2.11.7-alpine";
  caddyUid = 889;
  caddyGid = 889;
  domain = "megaparsec.ca";
  certPath = "/certs/internal-tls-cert";
  keyPath = "/certs/internal-tls-key";

  site = name: body: ''
    ${name}.${domain} {
      tls ${certPath} ${keyPath}
      ${body}
    }
  '';

  caddyfile = pkgs.writeText "Caddyfile" ''
    {
      auto_https off
    }

    ${site "pihole" "reverse_proxy pihole:80"}
    ${site "freshrss" "reverse_proxy freshrss:80"}
    ${site "monitor" ''
      reverse_proxy beszel-hub:8090 {
        transport http {
          read_timeout 360s
        }
      }
    ''}
    ${site "budget" "reverse_proxy actualbudget:5006"}
    ${site "git" "reverse_proxy forgejo:3000"}
  '';
in
{
  users.groups.caddy = {
    gid = caddyGid;
  };
  users.users.caddy = {
    uid = caddyUid;
    group = "caddy";
    isSystemUser = true;
  };

  age.secrets = {
    internal-tls-cert = {
      file = ../../secrets/internal-tls-cert.age;
      owner = "caddy";
      group = "caddy";
      mode = "0400";
    };
    internal-tls-key = {
      file = ../../secrets/internal-tls-key.age;
      owner = "caddy";
      group = "caddy";
      mode = "0400";
    };
  };

  virtualisation.oci-containers.containers.caddy = {
    autoStart = true;
    image = "caddy:${caddyVersion}";
    ports = [
      "443:443/tcp"
    ];
    volumes = [
      "${caddyfile}:/etc/caddy/Caddyfile:ro"
      "${config.age.secrets.internal-tls-cert.path}:${certPath}:ro"
      "${config.age.secrets.internal-tls-key.path}:${keyPath}:ro"
    ];
    extraOptions = [
      "--user=${toString caddyUid}:${toString caddyGid}"
    ];
  };
}
