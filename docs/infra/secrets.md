# Secrets

Secrets are managed differently per host. In all cases we **never** store unencrypted secrets in git!

## Blahaj

Uses [agenix](https://github.com/ryantm/agenix) with age-encrypted files in `secrets/`. To edit a secret:

```bash
cd secrets
agenix -e <name>.age
```

The `.age` files are encrypted in git.

### Host key backup and recovery

Agenix uses the host's SSH key to encrypt secrets. If you need to rebuild blahaj from scratch, you must restore the host's private SSH key before running `nh os switch .` so agenix can decrypt the secrets.

On `Schooner` read the keys from 1Password into files:

```bash
op read op://Private/Blahaj\ Host\ Key/private\ key > ssh_host_ed25519_key
op read op://Private/Blahaj\ Host\ Key/public\ key > ssh_host_ed25519_key.pub
```

Use `scp` to copy them to `blahaj` and delete the local copies:

```bash
scp ssh_host_ed25519_key* blahaj:~
rm ssh_host_ed25519_key*
```

Login to `blahaj` and then run:

```bash
sudo mkdir -p /etc/ssh
sudo mv ~/ssh_host_ed25519_key* /etc/ssh
sudo chmod 600 /etc/ssh/ssh_host_ed25519_key
```

Now run `nh os switch .` — agenix will be able to decrypt the secrets

#### Lost key

**If you lose the key:** You can generate a new host key and re-encrypt the secrets by updating `static/blahaj/blahaj_host_key` with the new public key and running `agenix --rekey`.

## Schooner

Typically we keep our private key in 1Password, but we have to temporarily export it to `~/.ssh` to edit these encrypted files. We can then delete the private key when done.

```bash
op read op://Private/RCD\ 2022\ SSH\ Key/private\ key > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
```

When done:

```bash
rm ~/.ssh/id_ed25519
```
