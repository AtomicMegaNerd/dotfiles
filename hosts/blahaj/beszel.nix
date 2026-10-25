{ config, ... }:
{
  age.secrets.beszel-agent.file = ../../secrets/beszel-agent.age;

  virtualisation.oci-containers.containers.beszel-hub = {
    autoStart = true;
    image = "henrygd/beszel:0.21.1";
    ports = [
      "127.0.0.1:8090:8090/tcp"
    ];
    volumes = [
      "/var/lib/beszel/data:/beszel_data"
      "/run/beszel_socket:/beszel_socket"
    ];
    environment = {
      APP_URL = "https://monitor.megaparsec.ca";
    };
    extraOptions = [
      "--network=podman-ipv6"
      "--ip6=fd00::12"
    ];
  };

  virtualisation.oci-containers.containers.beszel-agent = {
    autoStart = true;
    image = "henrygd/beszel-agent:0.21.1";
    volumes = [
      "/var/lib/beszel/agent:/var/lib/beszel-agent"
      "/run/beszel_socket:/beszel_socket"
      "/run/podman/podman.sock:/run/podman/podman.sock:ro"
      "/run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro"
    ];
    environment = {
      DOCKER_HOST = "unix:///run/podman/podman.sock";
      HUB_URL = "http://localhost:8090";
      LISTEN = "/beszel_socket/beszel.sock";
      SERVICE_PATTERNS = "podman-*";
    };
    environmentFiles = [ config.age.secrets.beszel-agent.path ];
    extraOptions = [ "--network=host" ];
  };

  systemd.services.podman-beszel-agent = {
    requires = [ "podman-beszel-hub.service" ];
    after = [ "podman-beszel-hub.service" ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-beszel-hub.service" ];
    before = [ "podman-beszel-hub.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/beszel/data 0755 root root -"
    "d /var/lib/beszel/agent 0755 root root -"
    "d /run/beszel_socket 0755 root root -"
  ];
}
