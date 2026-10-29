# Forgejo

> [!NOTE]
> This is not deployed yet.

[Forgejo](https://forgejo.org/) is configured as an internal Git forge at [git.megaparsec.ca](https://git.megaparsec.ca), with one Actions runner for CI/CD.

## Prerequisites

- DNS and TLS for `git.megaparsec.ca` (see [DNS](./dns.md) and [Internal TLS](./tls-internal.md)).

## Server configuration

The Forgejo server configuration is [forgejo.nix](../hosts/blahaj/forgejo.nix).

- Forgejo server runs in a podman container. Needs to be wired to caddy [services.md](./services.md).

- Forgejo server container runs on two private static IPv6 networks:
  - `podman-ipv6` which all containers on podman share
  - `forgejo` which the server and runner with both share

## Runner configuration

The host and guest configuration lives in [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix). It runs the forgejo-runner service and podman in a MicroVM. The runner VM must:

- Use KVM/QEMU
- Uses default `node` label for the runner.
- Run continuously.
- Support 1 job at a time.
- Have 2 vCPUs and max 3 GiB of RAM.
  - Dynamically return memory to host OS when idle to conserve memory.
    - Use `microvm.balloon = true`.
- Run podman internally to do container builds.
- Must run on the `forgejo` internal IPv6 network.
  - Does not need HTTP access via caddy.
- Use a nixos-unstable VM image to get the latest `forgejo-runner` service and `podman`.
- Include a beszel agent inside the VM to monitor RAM and CPU for the VM.
  - [Beszel](../hosts/blahaj/beszel.nix) must also join the `forgejo` network to talk this agent.

## Initial setup

### Server Setup

- Import [forgejo.nix](../hosts/blahaj/forgejo.nix) into [configuration.nix](../hosts/blahaj/configuration.nix), then apply the configuration.
- Open Forgejo and complete the installer. Choose SQLite and create the admin account under **Administrator Account Settings**; self-registration can remain disabled.

### Runner Setup

TBD

## Links

- [Forgejo Docker installation](https://forgejo.org/docs/latest/admin/installation/docker/)
- [Forgejo Actions runner registration](https://forgejo.org/docs/latest/admin/actions/registration/)
- [microvm.nix](https://github.com/microvm-nix/microvm.nix)
