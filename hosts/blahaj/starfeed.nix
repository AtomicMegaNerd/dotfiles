{ config, ... }:
{
  virtualisation.oci-containers.containers.starfeed = {
    autoStart = true;
    image = "atomicmeganerd/starfeed:0.4.1";
    environmentFiles = [ config.age.secrets.starfeed-env.path ];
    dependsOn = [ "freshrss" ];
    extraOptions = [
      "--network=podman-ipv6"
    ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-starfeed.service" ];
    before = [ "podman-starfeed.service" ];
  };

  age.secrets.starfeed-env.file = ../../secrets/starfeed-env.age;
}
