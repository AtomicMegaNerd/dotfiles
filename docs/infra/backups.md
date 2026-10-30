# Backups

[restic](https://restic.net/) backs up every service that keeps state on blahaj. See [backup.nix](../hosts/blahaj/backup.nix).

| Service       | Backed up               |
| ------------- | ----------------------- |
| Forgejo       | `/var/lib/forgejo`      |
| Actual Budget | `/var/lib/actualbudget` |
| Beszel        | `/var/lib/beszel`       |
| FreshRSS      | `/etc/freshrss`         |
| Pi-hole       | `/etc/pihole`           |

Caddy, Starfeed, cloudflare-ddns and the runner VM keep no state. Their config is in Nix and their secrets are in agenix.

## How it works

- Runs every night at 03:00 and writes to `/data/backups/restic`, a separate disk from the OS.
- The containers are stopped for the few seconds the backup takes, so SQLite databases are copied consistently. Pi-hole DNS is briefly unavailable.
- Keeps 7 daily, 4 weekly and 6 monthly snapshots.
- The repository password is `secrets/restic-password.age`. Keep a copy in 1Password. Without it the backups can't be read.

## Setup

Create the password secret before the first deploy:

```bash
openssl rand -base64 32 | agenix -e restic-password.age
git add secrets/restic-password.age
```

## Use

```bash
sudo systemctl start restic-backups-local   # back up now
sudo restic-local snapshots                 # list snapshots
```

## Restore

1. Stop the service: `sudo systemctl stop podman-<service>`.
2. Restore into a scratch directory: `sudo restic-local restore latest --target /tmp/restore --include <path>`.
3. Copy the data from `/tmp/restore<path>` back into place.
4. Start the service: `sudo systemctl start podman-<service>`.

## Links

- [restic documentation](https://restic.readthedocs.io/)
- [Services](../services/services.md)
