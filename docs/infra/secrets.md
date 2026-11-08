# Managing Secrets With `agenix`

We use [agenix](https://github.com/ryantm/agenix) to manage the secrets in our flake so that we can safely store encrypted secrets in git. The following SSH keys are used to encrypt/decrypt:

- `op://Private/RCD 2022 SSH Key/private key` - for `Schooner`
  - Never stored
- `op://Private/Blahaj Host Key/private key` - For `blahaj`
  - Stored at `/etc/ssh/ssh_host_ed25519_key`

## Creating/Editing Secrets

Before creating a secret we must add an entry to [agenix-rules.nix](../../secrets/agenix-rules.nix). Note that we need an entry for each secret:

```nix
let
  user = builtins.readFile ../static/rcd_pub_key;
  blahaj = builtins.readFile ../static/blahaj/blahaj_host_key;
in
{
  "secret1.age".publicKeys = [
    user
    blahaj
  ];

  "secret2.age".publicKeys = [
    user
    blahaj
  ];

  # ... more secrets
}
```

On `Schooner` we create/edit the secret using our private SSH key pulled from 1Password:

```fish
cd secrets
agenix -e <name>.age -i (op read "op://Private/RCD 2022 SSH Key/private key" | psub)
```

We can then refer to the secret in our flake with code like this:

```nix
thing = {
  # Other nix stuff
  age.secrets.<name>.file = ../../secrets/<name>.age;
};
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
