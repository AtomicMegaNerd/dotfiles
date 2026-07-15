{ config, ... }:
{
  virtualisation.oci-containers.containers.starfeed = {
    autoStart = true;
    image = "atomicmeganerd/starfeed:0.5.0";
    environment = {
      STARFEED_CONFIG_PATH = "/app/starfeed.toml";
    };
    dependsOn = [ "freshrss" ];
    extraOptions = [
      "--network=podman-ipv6"
      "--volume=${config.age.secrets.starfeed-config.path}:/app/starfeed.toml:ro"
    ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-starfeed.service" ];
    before = [ "podman-starfeed.service" ];
  };

  age.secrets.starfeed-config = {
    file = ../../secrets/starfeed-config.age;
    mode = "0444";
  };
}
