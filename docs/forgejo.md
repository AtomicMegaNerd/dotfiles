# Forgejo

> [!NOTE]
> This is not deployed next, still deciding if this is worth the complexity right now.

[Forgejo](https://forgejo.org/) is configured as an internal Git forge at [git.megaparsec.ca](https://git.megaparsec.ca), with one Podman-based Actions runner planned for personal projects.

## Prerequisites

- DNS and TLS for `git.megaparsec.ca` (see [DNS](./dns.md) and [Internal TLS](./tls-internal.md)).

## Blahaj configuration

The Forgejo service module is [forgejo.nix](../hosts/blahaj/forgejo.nix) and is imported by [configuration.nix](../hosts/blahaj/configuration.nix). It configures the rootless Forgejo 17 container, SQLite, SSH on port 2222, and the static Podman address. The Caddy address and route are configured in [caddy.nix](../hosts/blahaj/caddy.nix), the `git.megaparsec.ca` DNS record is configured in [dnsmasq.conf](../static/blahaj/dnsmasq.conf), and container addresses are documented in [Podman](./podman.md).

## Runner configuration

The runner configuration lives in [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix). It has capacity one and uses the `node` job label with the rootful Podman socket. Its config file is generated at runtime using the Agenix token, so the token is not stored in the Nix store. The runner module also depends on Caddy and Forgejo being started first.

`data.forgejo.org/forgejo/runner` is the runner daemon image. The `node` label selects a separate [Node Alpine job image](https://code.forgejo.org/oci/-/packages/container/node/24-alpine3.23). The runner image defaults to UID 1000; this module runs it as root to access Blahaj's rootful Podman socket. `docker_host` passes that socket to jobs, so built images land in Blahaj's Podman store.

## Initial setup

- Import [forgejo.nix](../hosts/blahaj/forgejo.nix) in [configuration.nix](../hosts/blahaj/configuration.nix), then run `nh os switch .`.
- Open Forgejo and complete the installer. Choose SQLite and create the admin account under **Administrator Account Settings**; self-registration can remain disabled.
- In your account, open **Settings → Actions → Runners**, create a runner, and copy its UUID and token.
- Replace the placeholder runner UUID in [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix) with the UUID that was copied down.
- Create the encrypted `secrets/forgejo-runner-token.age` file using Agenix (see [Secrets](./secrets.md)).
- Import [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix) in [configuration.nix](../hosts/blahaj/configuration.nix), then run `nh os switch .` again.
- Verify the runner and a job can reach `git.megaparsec.ca` through Caddy and trust the mounted CA bundle.
- Test `docker build` in a workflow using `runs-on: node` and a repository with a `Dockerfile`.

## Links

- [Forgejo Docker installation](https://forgejo.org/docs/latest/admin/installation/docker/)
- [Forgejo Actions runner registration](https://forgejo.org/docs/latest/admin/actions/registration/)
- [Forgejo runner Docker installation](https://forgejo.org/docs/latest/admin/actions/installation/docker/)
- [Forgejo runner socket access](https://forgejo.org/docs/latest/admin/actions/docker-access/)
