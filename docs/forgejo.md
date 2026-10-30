# Forgejo

[Forgejo](https://forgejo.org/) is the internal Git forge at [git.megaparsec.ca](https://git.megaparsec.ca). Its Actions runner runs in a microVM on blahaj.

- **Server:** a rootless Podman container, [forgejo.nix](../hosts/blahaj/forgejo.nix). Caddy proxies HTTPS to it and SSH is published on port 2222. Data is in `/var/lib/forgejo`.
- **Runner:** a NixOS microVM, [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix). 2 vCPUs, up to 3 GiB RAM, rootful Podman inside for `podman build`, and its own Beszel agent.
- **Network:** all of it is dual stack. The shared values live in the `let` block of [configuration.nix](../hosts/blahaj/configuration.nix). The VM sits on its own NAT bridge, `vm-bridge`, and reaches Pi-hole, Caddy and the internet through the host. Containers are described in [Podman](./podman.md).

DNS and the certificate come from [DNS](./dns.md) and [Internal TLS](./tls-internal.md).

## Deploy

### 1. Server

1. Import `./forgejo.nix` in `configuration.nix`. The first deploy changes the network and loads a kernel module, so use `nh os boot .` and reboot.
2. Open [git.megaparsec.ca](https://git.megaparsec.ca) and finish the installer. Keep the prefilled settings, choose SQLite, and create the admin account under **Administrator Account Settings**.

### 2. Runner

1. In Forgejo, open `/admin/actions/runners` and choose **Create new runner**. It shows a UUID and a token once.
2. Put the UUID in `forgejo-runner.nix`. It is an identifier, not a secret.
3. Save only the token in `secrets/forgejo-runner-token.age` with `agenix -e`.
4. In the [Beszel](./beszel.md) Hub, add a system for the VM. Save its `KEY=` and `TOKEN=` lines in `secrets/runner-beszel-agent.age`.
5. `git add` both `.age` files and import `forgejo-runner.nix` in `configuration.nix`.
6. Run `nh os switch .`. The first build of the VM takes a while.

The runner shows as **Idle** in Forgejo and the VM shows as online in Beszel.

## Verify

From a machine on the LAN, with blahaj's addresses:

```bash
curl -4 -sI https://git.megaparsec.ca | head -1
curl -6 -sI https://git.megaparsec.ca | head -1
nc -4zv <blahaj-ipv4> 2222
nc -6zv <blahaj-ipv6> 2222
```

From blahaj, check the VM's addresses:

```bash
ping -c2 10.77.0.2
ping -6 -c2 fd77::2
```

Then push a workflow to a test repository. `runs-on: node` matches the runner's `node:host` label:

```yaml
on: [push]
jobs:
  net:
    runs-on: node
    steps:
      - run: curl -4 -sI --max-time 10 https://one.one.one.one | head -1
      - run: curl -6 -sI --max-time 10 https://one.one.one.one | head -1
      - run: printf 'FROM docker.io/library/alpine\nRUN echo built\n' | podman build -f - .
```

## Notes

- To add another microVM, copy the runner module with its own `index`, a tap named `vm-tap-<name>` and a unique MAC. The host needs no changes.

## Todo

- [ ] Setup ability to publish to Docker Hub (if any setup needed).
- [ ] Setup ability to mirror to GitHub.

## Links

- [Forgejo Docker installation](https://forgejo.org/docs/latest/admin/installation/docker/)
- [Forgejo Actions runner registration](https://forgejo.org/docs/latest/admin/actions/registration/)
- [microvm.nix](https://github.com/microvm-nix/microvm.nix)
