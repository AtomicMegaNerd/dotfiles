# Beszel monitoring

[Beszel](https://beszel.dev) is a lightweight monitoring system. It consists of a hub and a set of agents.

## Prerequisites

- DNS records setup (see [dns.md](./dns.md)).
- TLS cert generated (see [tls-internal.md](./tls-internal.md)).

## Blahaj configuration

The Hub and Agent are configured in [beszel.nix](../hosts/blahaj/beszel.nix).

- The Hub's port is bound to loopback for the host-network Agent
- [Caddy](./caddy.md) reaches it by the container name `beszel-hub` (see [Podman](./podman.md)).
- The Forgejo runner VM runs its own Agent, which connects out to the Hub at `https://monitor.megaparsec.ca`. See [Forgejo](./forgejo.md).

## Initial setup

Activate the Hub configuration in [beszel.nix](../hosts/blahaj/beszel.nix) first and apply it. Then open [monitor.megaparsec.ca](https://monitor.megaparsec.ca) and create the initial account.

## Adding an Agent

In the Hub, add a system of type `Docker` named `blahaj` with **Host / IP** set to `/beszel_socket/beszel.sock`. Copy the `KEY` and `TOKEN` shown for the Agent.

Add `beszel-agent.age` to `secrets` according to the procedure in [secrets.md](./secrets.md) with the KEY and TOKEN:

```text
KEY=<key-from-hub>
TOKEN=<token-from-hub>
```

Then add the Agent to [beszel.nix](../hosts/blahaj/beszel.nix). Its version must match the Hub's.

### Agent in a microVM

The runner VM's Agent is configured in [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix). Add a system in the Hub for it. The `KEY` is the Hub's public key, the same for every Agent. The `TOKEN` is unique to each system. Both go in `secrets/runner-beszel-agent.age` as `KEY=` and `TOKEN=` lines.

## Notifications

> [!NOTE]
> Not implemented yet. This is possible future work.

### Signal

Run a Signal API server such as [signal-cli-rest-api](https://github.com/bbernhard/signal-cli-rest-api) and register or link it with a Signal account. In the Hub, open **Settings > Notifications** and add a Shoutrrr URL using this format:

```text
signal://<api-host>:8080/<sender-number>/<recipient-number>
```

### Failed service alerts

The D-Bus socket mount lets the Agent monitor systemd services. Beszel polls service status about every 10 minutes, so a service failure may take that long to appear. `SERVICE_PATTERNS="podman-*"` limits the monitored services to Podman units.

In the Hub, create a notification channel and enable the **Failed Services** alert for `blahaj`, selecting that channel. Blahaj cannot send an alert if the whole host is offline, since the Hub and notification delivery run there.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](./podman.md) - Podman network and DNS
- [Beszel Getting Started](https://beszel.dev/guide/getting-started)
- [Beszel Agent Installation](https://beszel.dev/guide/agent-installation)
- [Beszel Reverse Proxy](https://beszel.dev/guide/reverse-proxy)
- [Podman Monitoring](https://beszel.dev/guide/podman)
