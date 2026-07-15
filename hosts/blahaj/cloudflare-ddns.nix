{ config, ... }:
{
  age.secrets.cloudflare-ddns-token.file = ../../secrets/cloudflare-ddns-token.age;

  services.cloudflare-ddns = {
    enable = true;
    credentialsFile = config.age.secrets.cloudflare-ddns-token.path;
    domains = [ "megaparsec.ca" ];
    proxied = "false";
  };

  systemd.services.cloudflare-ddns = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
