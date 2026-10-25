# Forgejo

[Forgejo](https://forgejo.org/) is planned as an internal Git forge at [https://git.megaparsec.ca](https://git.megaparsec.ca), with one Podman-based Actions runner for personal projects.

## Prerequisites

- DNS and TLS for `git.megaparsec.ca` (see [DNS](./dns.md) and [Internal TLS](./tls-internal.md)).

## Blahaj configuration

Add `./forgejo.nix` to [configuration.nix](../hosts/blahaj/configuration.nix).

```nix
{ ... }:
let
  forgejoVersion = "17.0.0";
  forgejoUid = 891;
  forgejoGid = 891;
in
{
  users.groups.forgejo.gid = forgejoGid;
  users.users.forgejo = {
    uid = forgejoUid;
    group = "forgejo";
    isSystemUser = true;
  };

  networking.firewall.allowedTCPPorts = [ 2222 ];

  virtualisation.oci-containers.containers.forgejo = {
    autoStart = true;
    image = "codeberg.org/forgejo/forgejo:${forgejoVersion}-rootless";
    user = "${toString forgejoUid}:${toString forgejoGid}";
    ports = [ "2222:2222/tcp" ];
    volumes = [ "/var/lib/forgejo:/var/lib/gitea" ];
    environment = {
      USER_UID = toString forgejoUid;
      USER_GID = toString forgejoGid;
      FORGEJO__database__DB_TYPE = "sqlite3";
      FORGEJO__server__DOMAIN = "git.megaparsec.ca";
      FORGEJO__server__ROOT_URL = "https://git.megaparsec.ca/";
      FORGEJO__server__SSH_DOMAIN = "git.megaparsec.ca";
      FORGEJO__server__SSH_PORT = "2222";
      FORGEJO__server__SSH_LISTEN_PORT = "2222";
      FORGEJO__server__START_SSH_SERVER = "true";
      FORGEJO__service__DISABLE_REGISTRATION = "true";
      FORGEJO__actions__ENABLED = "true";
    };
    extraOptions = [
      "--network=podman-ipv6"
      "--ip6=fd00::14"
    ];
  };

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-forgejo.service" ];
    before = [ "podman-forgejo.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/forgejo 0750 ${toString forgejoUid} ${toString forgejoGid} -"
  ];
}
```

Assign Caddy `fd00::15` in `hosts/blahaj/caddy.nix`, add the `git.megaparsec.ca` record to `static/blahaj/dnsmasq.conf`, and record the addresses in [Podman](./podman.md). Add the Caddy route as described in [Caddy](./caddy.md).

## Runner configuration

Put the runner token in `secrets/forgejo-runner-token.age`. Nix generates the runner's required config file at runtime from the settings below and the UUID returned by Forgejo.

```nix
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
      options = "--network=podman-ipv6 --add-host=git.megaparsec.ca:fd00::15 --volume=${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt:ro";
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
```

`data.forgejo.org/forgejo/runner` is the runner daemon image. The `node` label selects a separate [Node Alpine job image](https://code.forgejo.org/oci/-/packages/container/node/24-alpine3.23). The runner image defaults to UID 1000; this module runs it as root to access Blahaj's rootful Podman socket. `docker_host` passes that socket to jobs, so built images land in Blahaj's Podman store.

## Initial setup

1. Import `forgejo.nix` without the runner module and run `nh os switch .`.
2. Open Forgejo and complete the installer. Choose SQLite and create the admin account under **Administrator Account Settings**; self-registration can remain disabled.
3. In your account, open **Settings → Actions → Runners**, create a runner, and copy its UUID and token.
4. Add the runner token to `secrets/forgejo-runner-token.age` using Agenix (see [Secrets](./secrets.md)). Nix generates the runner config at service start.
5. Add/import `forgejo-runner.nix` and run `nh os switch .` again.
6. Verify the runner and a job can reach `git.megaparsec.ca` through Caddy and trust the mounted CA bundle.
7. Test `docker build` in a workflow using `runs-on: node` and a repository with a `Dockerfile`.

## Links

- [Forgejo Docker installation](https://forgejo.org/docs/latest/admin/installation/docker/)
- [Forgejo Actions runner registration](https://forgejo.org/docs/latest/admin/actions/registration/)
- [Forgejo Actions Podman configuration](https://forgejo.org/docs/latest/admin/actions/installation/binary/)
- [Forgejo runner socket access](https://forgejo.org/docs/latest/admin/actions/docker-access/)
