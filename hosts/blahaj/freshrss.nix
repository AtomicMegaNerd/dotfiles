let
  freshRssVersion = "1.30.4";
in
{
  virtualisation.oci-containers.containers.freshrss = {
    autoStart = true;
    image = "freshrss/freshrss:${freshRssVersion}";
    volumes = [
      "/etc/freshrss/data:/var/www/FreshRSS/data"
      "/etc/freshrss/extensions:/var/www/FreshRSS/extensions"
    ];
    environment = {
      TZ = "America/Edmonton";
      CRON_MIN = "15,45";
    };
  };
}
