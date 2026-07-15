{ config, ... }:
{
  # This user maps to the UID of the default noroot user in the distroless images like
  # gcr.io/distroless/static-debian13:nonroot. We need to give this user permissions to
  # the decrypted starfeed.toml file
  users.users.starfeed = {
    isSystemUser = true;
    uid = 65532;
    group = "nogroup";
  };

  # We give ownership of the decrypted file to this starfeed user
  age.secrets.starfeed-config = {
    file = ../../secrets/starfeed-config.age;
    owner = "starfeed";
    mode = "0400";
  };

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

}
