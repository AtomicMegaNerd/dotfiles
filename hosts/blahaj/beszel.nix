{
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

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-beszel-hub.service" ];
    before = [ "podman-beszel-hub.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/beszel/data 0755 root root -"
    "d /run/beszel_socket 0755 root root -"
  ];
}
