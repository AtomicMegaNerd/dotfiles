# Beszel monitoring

[Beszel](https://beszel.dev) is a lightweight monitoring service. We are running Beszel as a podman container.

## Blahaj configuration

See [beszel.nix](../hosts/blahaj/beszel.nix).

- `blahaj` has its own agent running as a container.
- The [Forgejo Runner MicroVM](../../hosts/blahaj/forgejo-runner.nix) also runs its own agent.

## Initial setup

Activate the Hub configuration in [beszel.nix](../hosts/blahaj/beszel.nix) first and apply it. Then open [monitor.megaparsec.ca](https://monitor.megaparsec.ca) and create the initial account.

## Adding an Agent

In the Bleszel GUI add the agent for the correct host (see below for Docker vs Binary). Copy the `KEY` and `TOKEN`.

> [!IMPORTANT]
> For agents on the same host as the Beszel Hub set **Host / IP** set to `/beszel_socket/beszel.sock`.

Add `beszel-agent.age` to `secrets` according to the procedure in [secrets.md](../infra/secrets.md) with the KEY and TOKEN:

```text
KEY=<key-from-hub>
TOKEN=<token-from-hub>
```

Finally add the Agent to [beszel.nix](../hosts/blahaj/beszel.nix). Its version must match the Hub's.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [Beszel Getting Started](https://beszel.dev/guide/getting-started)
- [Beszel Agent Installation](https://beszel.dev/guide/agent-installation)
- [Beszel Reverse Proxy](https://beszel.dev/guide/reverse-proxy)
- [Podman Monitoring](https://beszel.dev/guide/podman)
