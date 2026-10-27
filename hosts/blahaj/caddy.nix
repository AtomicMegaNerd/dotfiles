{ config, pkgs, ... }:
let
  caddyVersion = "2.11.7-alpine";
  caddyUid = 889;
  caddyGid = 889;

  # TODO: See if there is a Nix way to do this....
  caddyfile = pkgs.writeText "Caddyfile" ''
    {
      auto_https off
    }

    pihole.megaparsec.ca {
      tls /certs/internal-tls-cert /certs/internal-tls-key
      reverse_proxy [fd00::10]:80
    }

    freshrss.megaparsec.ca {
      tls /certs/internal-tls-cert /certs/internal-tls-key
      reverse_proxy [fd00::11]:80
    }

    monitor.megaparsec.ca {
      tls /certs/internal-tls-cert /certs/internal-tls-key
      reverse_proxy [fd00::12]:8090 {
        transport http {
          read_timeout 360s
        }
      }
    }

    budget.megaparsec.ca {
      tls /certs/internal-tls-cert /certs/internal-tls-key
      reverse_proxy [fd00::13]:5006
    }

    git.megaparsec.ca {
      tls /certs/internal-tls-cert /certs/internal-tls-key
      reverse_proxy [fd00::14]:3000
    }
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
      "${config.age.secrets.internal-tls-cert.path}:/certs/internal-tls-cert:ro"
      "${config.age.secrets.internal-tls-key.path}:/certs/internal-tls-key:ro"
    ];
    extraOptions = [
      "--network=podman-ipv6"
      "--ip6=fd00::15"
      "--user=${toString caddyUid}:${toString caddyGid}"
    ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-caddy.service" ];
    before = [ "podman-caddy.service" ];
  };
}
