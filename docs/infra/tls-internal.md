# TLS For `megaparsec.ca` on Internal LAN

This guide covers setting up trusted TLS certificates for internal services on the `megaparsec.ca` domain.

## Prerequisites

- Internal DNS must be configured and working. See [DNS Setup](./dns.md).
- Install `nss.tools` for Firefox before starting.
- Install `mkcert` to generate the certs.

## Procedure

### Create the root CA

```bash
mkcert -install
```

This creates the Root CA files and adds the certificate to your Mac's trust store:

- `rootCA.pem` (public cert)
- `rootCA-key.pem` (private key)

### Secure the private key in 1Password

Store the private CA key in 1Password and remove it from local disk:

```bash
op document create "$(mkcert -CAROOT)/rootCA-key.pem" --title "rcd-rootCA-private.pem"
rm "$(mkcert -CAROOT)/rootCA-key.pem"
```

### Distribute the root CA

Copy `rootCA.pem` to `static/` in this repo:

```bash
cp "$(mkcert -CAROOT)/rootCA.pem" static/rcd-rootCA-pub.pem
```

### On macOS

The certificate is listed in `security.pki.certificateFiles` in [darwin.nix](../hosts/Schooner/darwin.nix). Apply it with `nh darwin switch`.

### On NixOS

The certificate is listed in `security.pki.certificateFiles` in [configuration.nix](../hosts/blahaj/configuration.nix). Apply it with `nh os switch`. The Forgejo runner VM trusts it too, in [forgejo-runner.nix](../hosts/blahaj/forgejo-runner.nix).

### Generate certs

When you need to generate new certificates, retrieve the private key from 1Password:

```bash
op document get "rcd-rootCA-private.pem" --out-file "$(mkcert -CAROOT)/rootCA-key.pem"
mkcert \
  -cert-file internal.pem \
  -key-file internal-key.pem \
  freshrss.megaparsec.ca \
  pihole.megaparsec.ca \
  gateway.megaparsec.ca \
  blahaj.megaparsec.ca \
  schooner.megaparsec.ca \
  monitor.megaparsec.ca \
  budget.megaparsec.ca \
  git.megaparsec.ca
rm "$(mkcert -CAROOT)/rootCA-key.pem"
```

This creates:

- `internal.pem` - Certificate file
- `internal-key.pem` - Private key file

### Add certs to flake using `agenix`

Store these securely in the flake using agenix:

```bash
mv internal.pem secrets/
mv internal-key.pem secrets/
cd ./secrets
agenix -e internal-tls-cert.age < internal.pem
agenix -e internal-tls-key.age < internal-key.pem
```

### Upload cert for Ubiquiti UCG

In the UCG gateway admin interface at `gateway.megaparsec.ca` upload the certificate and key files (`internal.pem` and `internal-key.pem`).

### Delete the internal PEM files

```bash
rm secrets/internal*.pem
```

## Links

- [mkcert GitHub Repository](https://github.com/FiloSottile/mkcert)
