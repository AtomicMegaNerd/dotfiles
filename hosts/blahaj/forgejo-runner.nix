{ config, pkgs, ... }:
let
  forgejoRunnerUuid = "replace-with-uuid-from-forgejo";
  runnerConfig = (pkgs.formats.yaml { }).generate "forgejo-runner.yml" {
    runner = {
      capacity = 1;
      labels = [ "node:docker://data.forgejo.org/oci/node:24-alpine3.23" ];
    };
    host.workdir_parent = "/var/lib/forgejo-runner/work";
    server.connections.forgejo = {
      url = "https://git.megaparsec.ca/";
      uuid = forgejoRunnerUuid;
      token = "$RUNNER_TOKEN";
    };
    runner.envs = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      GIT_SSL_CAINFO = "/etc/ssl/certs/ca-certificates.crt";
      NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
    };
    container = {
      docker_host = "unix:///run/podman/podman.sock";
      network = "podman-ipv6";
      options = "--add-host=git.megaparsec.ca:fd00::15 --volume=${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt:ro";
    };
  };
in
{
  age.secrets.forgejo-runner-token = {
    file = ../../secrets/forgejo-runner-token.age;
    mode = "0400";
  };

  systemd.services.prepare-forgejo-runner-config = {
    requiredBy = [ "podman-forgejo-runner.service" ];
    before = [ "podman-forgejo-runner.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      install -d -m 0700 /run/forgejo-runner
      RUNNER_TOKEN="$(${pkgs.coreutils}/bin/cat ${config.age.secrets.forgejo-runner-token.path})" \
        ${pkgs.gettext}/bin/envsubst '$RUNNER_TOKEN' \
        < ${runnerConfig} \
        > /run/forgejo-runner/runner-config.yml
      chmod 0400 /run/forgejo-runner/runner-config.yml
    '';
  };

  systemd.services.podman-forgejo-runner = {
    requires = [
      "prepare-forgejo-runner-config.service"
      "podman-forgejo.service"
      "podman-caddy.service"
    ];
    after = [
      "prepare-forgejo-runner-config.service"
      "podman-forgejo.service"
      "podman-caddy.service"
    ];
  };

  virtualisation.oci-containers.containers.forgejo-runner = {
    autoStart = true;
    image = "data.forgejo.org/forgejo/runner:13.2.0";
    user = "0:0";
    workdir = "/var/lib/forgejo-runner";
    cmd = [
      "forgejo-runner"
      "daemon"
      "--config"
      "/etc/forgejo-runner.yml"
    ];
    volumes = [
      "/run/forgejo-runner/runner-config.yml:/etc/forgejo-runner.yml:ro"
      "/run/podman/podman.sock:/run/podman/podman.sock"
      "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt:ro"
      "/var/lib/forgejo-runner:/var/lib/forgejo-runner"
    ];
    environment.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    extraOptions = [
      "--network=podman-ipv6"
      "--add-host=git.megaparsec.ca:fd00::15"
    ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-forgejo-runner.service" ];
    before = [ "podman-forgejo-runner.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/forgejo-runner 0750 root root -"
    "d /var/lib/forgejo-runner/work 0750 root root -"
  ];
}
