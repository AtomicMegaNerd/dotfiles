# Internal TLS guide (private LAN)

This guide covers setting up trusted TLS certificates for internal services accessible only on your local network using hostnames like `freshrss.megaparsec.ca`, `pihole.megaparsec.ca`, etc.

## Prerequisites

- Internal DNS must be configured and working. See [DNS Setup](./dns.md).
- Install `nss.tools` for Firefox before starting.

## Procedure

### Create the root CA

The `mkcert` package is installed via Home Manager on Schooner (see `hosts/Schooner/rcd.nix`).

After rebuilding with `nh home switch .`, create and install the Root CA:

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

Copy `rootCA.pem` to `static/` in your dotfiles repo:

```bash
cp "$(mkcert -CAROOT)/rootCA.pem" static/rcd-rootCA-pub.pem
```

### On macOS (Schooner)

Add to `hosts/Schooner/darwin.nix` and then apply with `nh darwin switch`:

```nix
{ pkgs, ... }:
{
  security.pki.certificateFiles = [
    ../../static/rcd-rootCA-pub.pem
  ];
}
```

### On NixOS (Blahaj)

Add to `hosts/blahaj/configuration.nix` and then apply with `nh os switch`:

```nix
{ pkgs, ... }:
{
  security.pki.certificateFiles = [
    ../../static/rcd-rootCA-pub.pem
  ];
}
```

### Generate service certificates

When you need to generate certificates, retrieve the private key from 1Password temporarily:

```bash
op document get "rcd-rootCA-private.pem" --out-file "$(mkcert -CAROOT)/rootCA-key.pem"
mkcert \
  -cert-file internal.pem \
  -key-file internal-key.pem \
  freshrss.megaparsec.ca pihole.megaparsec.ca gateway.megaparsec.ca blahaj.megaparsec.ca schooner.megaparsec.ca monitor.megaparsec.ca budget.megaparsec.ca

rm "$(mkcert -CAROOT)/rootCA-key.pem"
```

This creates:

- `internal.pem` - Certificate file
- `internal-key.pem` - Private key file

### Add certs to flake using `agenix`

First tell agenix which keys to use by adding the following entries to `secrets/agenix-rules.nix`:

```nix
"internal-tls-cert.age".publicKeys = [ user blahaj ];
"internal-tls-key.age".publicKeys = [ user blahaj ];
```

Store these securely in the flake using agenix:

```bash
mv internal.pem ../secrets/
mv internal-key.pem ../secrets/
cd ./secrets
agenix -e internal-tls-cert.age < internal.pem
agenix -e internal-tls-key.age < internal-key.pem
```

### Upload gateway certificate

For the UCG gateway admin interface at `gateway.megaparsec.ca`:

1. Navigate to Settings > Control Plane > Console > Certificates
2. Upload the certificate and key files (`internal.pem` and `internal-key.pem`)
3. The gateway will now use your internal CA-signed certificate

### Delete the internal PEM files

```bash
rm secrets/internal*.pem
```

### Set up Caddy reverse proxy

Make sure that we setup `caddy`. See [caddy.nix](../hosts/blahaj/caddy.nix).

## Maintenance

- **Rotation:** Regenerate certificates with `mkcert`, re-encrypt both `.age` files in `secrets/`, then run `nh os switch .`
- **New Services:** Add new hostnames to the `mkcert` command and regenerate
- **New Devices:** Nix-managed hosts (Schooner and blahaj) trust the CA automatically via `security.pki.certificateFiles`. Other devices need `rcd-rootCA-pub.pem` installed manually. See [Install the CA on Other Devices](#install-the-ca-on-other-devices).

## Install the CA on other devices

Without this, browsers show a certificate warning for `*.megaparsec.ca`. Use the file `static/rcd-rootCA-pub.pem`.

### iPhone / iPad

1. AirDrop or email `rcd-rootCA-pub.pem` to the device and open it.
2. Go to **Settings > Profile Downloaded** and tap **Install**.
3. Go to **Settings > General > About > Certificate Trust Settings** and turn on full trust for the certificate.

### Mac

1. Double-click `rcd-rootCA-pub.pem` to add it to Keychain Access.
2. Double-click the certificate in Keychain Access, expand **Trust**, and set it to **Always Trust**.

## Links

- [Podman](./podman.md) - Podman network and static IPv6 addresses
- [mkcert GitHub Repository](https://github.com/FiloSottile/mkcert)
- [Caddy Documentation](https://caddyserver.com/docs/)
