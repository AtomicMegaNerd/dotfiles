# Forgejo

[Forgejo](https://forgejo.org/) is the internal Git forge at [git.megaparsec.ca](https://git.megaparsec.ca).

We run Forgejo as a Podman container, [forgejo.nix](../hosts/blahaj/forgejo.nix).

## CI/CD Runner

We run the Forgejo Runner as a NixOS microVM. See [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix).

## Deploy

### 1. Server

1. Import [forgejo.nix](../../hosts/blahaj/forgejo.nix) into the configuration for the specified host.
2. Open [git.megaparsec.ca](https://git.megaparsec.ca) and finish the installer. Keep the prefilled settings, choose SQLite, and create the admin account under **Administrator Account Settings**.

### 2. Runner

1. In Forgejo, open `/admin/actions/runners` and choose **Create new runner**. Copy the UUID and the token.
2. Put the UUID in [forgejo-runner.nix](../../hosts/blahaj/forgejo-runner.nix). This is an identifier, not a secret.
3. Setup the token in `secrets/forgejo-runner-token.age` see [secrets.md](../infra/secrets.md)
4. In the [Beszel](./beszel.md) Hub, add a system for the VM. Save its `KEY` and `TOKEN` values in `secrets/runner-beszel-agent.age`.

If successful the runner will show as **Idle** in Forgejo and the VM shows as online in Beszel.

## Testing

Then push the wokflow below to a test repository:

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

If it builds we know the Runner works.

## Links

- [Services](./services.md) - Docs common to all services.
- [Podman](../infra/podman.md) - Podman network and DNS
- [Backups](../infra/backups.md) - Backup and restore
- [Forgejo Docker installation](https://forgejo.org/docs/latest/admin/installation/docker/)
- [Forgejo Actions runner registration](https://forgejo.org/docs/latest/admin/actions/registration/)
- [microvm.nix](https://github.com/microvm-nix/microvm.nix)
