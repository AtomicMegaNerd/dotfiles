# Secrets

Secrets are managed differently per host. In all cases we **never** store unencrypted secrets in
git!

---

## blahaj

Uses [agenix](https://github.com/ryantm/agenix) with age-encrypted files in `secrets/`. To edit a
secret:

```bash
agenix -e secrets/<name>.age
```

The `.age` files are encrypted in git.

### Host Key Backup and Recovery

Agenix uses the host's SSH key to encrypt secrets. If you need to rebuild blahaj from scratch, you
must restore the host's private SSH key before running `nh os rebuild .` so agenix can decrypt the
secrets.

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

Now run `nh os rebuild .` — agenix will be able to decrypt the secrets

#### Lost Key

**If you lose the key:** You can generate a new host key and re-encrypt the secrets by updating
`static/blahaj_host_key` with the new public key and running `agenix rekey`.

---

## Schooner

We use op to write any secrets that we want to be user-wide environment variables. For example:

Edit the file `./secrets/credentials.fish.tpl`:

```fish
set -gx CONTEXT7_API_KEY "op://Private/Context7/api-key"
```

When we run `nh home switch .` we will have to authenticate to `op` after which it will write the
secrets to `~/.config/fish/conf.d/credentials.fish`.

**IMPORTANT** the file `~/.config/fish/conf.d/credentials.fish` **MUST** be in `.gitignore`!
