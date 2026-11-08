# Managing Secrets With `agenix`

We use [agenix](https://github.com/ryantm/agenix) to manage the secrets in our flake so that we can safely store encrypted secrets in git. The following SSH keys are used to encrypt/decrypt:

- `op://Private/RCD 2022 SSH Key/private key` - for Schooner
  - Never stored
- `op://Private/Blahaj Host Key/private key` - For Blahaj
  - Stored at `/etc/ssh/ssh_host_ed25519_key`

## Schooner

On Schooner we can read the required SSH private key from 1Password directly:

```fish
cd secrets
agenix -e <name>.age -i (op read "op://Private/RCD 2022 SSH Key/private key" | psub)
```

## Blahaj

On blahaj only root can actually read the secrets via its host key.

### Re-Deploying Host Key for `blahaj`

To rebuild `blahaj`, restore the host's private SSH key before running `nh os switch`:

```fish
op read "op://Private/Blahaj Host Key/private key" | \
  ssh blahaj "umask 077 && cat > ~/ssh_host_ed25519_key"
op read "op://Private/Blahaj Host Key/public key" | \
  ssh blahaj "cat > ~/ssh_host_ed25519_key.pub"
```

Login to `blahaj` and run the following:

```bash
sudo install -o root -g root -m 600 ~/ssh_host_ed25519_key /etc/ssh/
sudo install -o root -g root -m 644 ~/ssh_host_ed25519_key.pub /etc/ssh/
rm ~/ssh_host_ed25519_key ~/ssh_host_ed25519_key.pub
```
