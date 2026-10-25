# Beszel Monitoring

Beszel runs a Hub on Blahaj and an Agent on each monitored system. The Blahaj Agent uses a Unix socket to communicate with the Hub.

## Pre-Requisites

- DNS records for `monitor.megaparsec.ca` added to DNS (see [dns.md](./dns.md).
- TLS cert generated for `monitor.megaparsec.ca` (see [tls-internal.md](./tls-internal.md).

## Blahaj configuration

The Hub and Blahaj Agent are configured in `hosts/blahaj/beszel.nix`, imported from
`hosts/blahaj/configuration.nix`.

```nix
{ config, ... }:
let
  beszelVersion = "0.21.1";
in
{
  virtualisation.oci-containers.containers.beszel-hub = {
    autoStart = true;
    image = "henrygd/beszel:${beszelVersion}";
    ports = [ "127.0.0.1:8090:8090/tcp" ];
    volumes = [
      "/var/lib/beszel/data:/beszel_data"
      "/run/beszel_socket:/beszel_socket"
    ];
    environment.APP_URL = "https://monitor.megaparsec.ca";
    extraOptions = [
      "--network=podman-ipv6"
      "--ip6=fd00::12"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/beszel 0755 root root -"
    "d /var/lib/beszel/data 0755 root root -"
    "d /var/lib/beszel/agent 0755 root root -"
    "d /run/beszel_socket 0755 root root -"
  ];

  systemd.services.create-podman-network = {
    wantedBy = [ "podman-beszel-hub.service" ];
    before = [ "podman-beszel-hub.service" ];
  };
}
```

The Hub's port is bound to loopback for the host-network Agent; Caddy reaches it directly over IPv6 (see [Podman](./podman.md)).

## Caddy

The route is configured in `hosts/blahaj/caddy.nix`:

```caddy
monitor.megaparsec.ca {
  tls /certs/internal-tls-cert /certs/internal-tls-key
  reverse_proxy [fd00::12]:8090 {
    transport http {
      read_timeout 360s
    }
  }
}
```

## Initial setup

Activate the Hub-only configuration, with the Caddy route, DNS record, and certificate in place:

```bash
nh os switch .
```

Open [monitor.megaparsec.ca](https://monitor.megaparsec.ca) and create the first account; Beszel makes this the admin account.

In the Hub, add a system of type `Docker` named `blahaj` with **Host / IP** set to `/beszel_socket/beszel.sock`. Copy the `KEY` and `TOKEN` shown for the Agent.

Add `beszel-agent.age` to `secrets/agenix-rules.nix`, encrypt it with Agenix, and put those values in it:

```text
KEY=<key-from-hub>
TOKEN=<token-from-hub>
```

Then add the Agent to the NixOS module:

```nix
age.secrets.beszel-agent.file = ../../secrets/beszel-agent.age;

virtualisation.oci-containers.containers.beszel-agent = {
  autoStart = true;
  image = "henrygd/beszel-agent:${beszelVersion}";
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
```

Activate again:

```bash
nh os switch .
```

Confirm `blahaj` appears online and that system and Podman container metrics populate.

## Notifications

> [!NOTE]
> Not implemented yet.

### Signal

Run a Signal API server such as [signal-cli-rest-api](https://github.com/bbernhard/signal-cli-rest-api) and register or link it with a Signal account. In the Hub, open **Settings > Notifications** and add a Shoutrrr URL using this format:

```text
signal://<api-host>:8080/<sender-number>/<recipient-number>
```

### Failed service alerts

The D-Bus socket mount lets the Agent monitor systemd services. Beszel polls service status about every 10 minutes, so a service failure may take that long to appear. `SERVICE_PATTERNS="podman-*"` limits the monitored services to Podman units.

In the Hub, create a notification channel and enable the **Failed Services** alert for `blahaj`, selecting that channel. Blahaj cannot send an alert if the whole host is offline, since the Hub and notification delivery run there.

## Links

- [Beszel Getting Started](https://beszel.dev/guide/getting-started)
- [Beszel Agent Installation](https://beszel.dev/guide/agent-installation)
- [Beszel Reverse Proxy](https://beszel.dev/guide/reverse-proxy)
- [Podman Monitoring](https://beszel.dev/guide/podman)
