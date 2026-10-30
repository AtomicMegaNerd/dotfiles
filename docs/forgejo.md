# Forgejo

[Forgejo](https://forgejo.org/) is the internal Git forge at [git.megaparsec.ca](https://git.megaparsec.ca), with one Actions runner for CI/CD in a microVM. See [DNS](./dns.md) and [Internal TLS](./tls-internal.md) for the name and certificate.

## Requirements

- HTTPS and DNS are dual stack for the home network. IPv6 preferred internally.
- Anything that talks to the internet or the LAN is dual stack.
- Containers reach each other by name.
- Forgejo SSH (2222) is open to the LAN, dual stack.
- The runner VM (nixos-unstable guest, 2 vCPUs, 3 GiB RAM cap) builds containers and has its own Beszel agent. It reaches Caddy (HTTPS only) and the internet through a shared microVM bridge with NAT on the host. Any later microVM joins the same bridge with no host changes.

## Server

[forgejo.nix](../hosts/blahaj/forgejo.nix) runs the rootless Forgejo image as uid 891. The host directory `/var/lib/forgejo` is bind-mounted to `/var/lib/gitea`, where the rootless image keeps its data. Caddy proxies `git.megaparsec.ca` to `forgejo:3000`, and SSH is published on port 2222.

## Host network (`configuration.nix`)

Every value used in more than one place is defined once in the `let` block and passed into the runner module.

```nix
{ pkgs, ... }:
let
  wan = "enp0s31f6";

  # Pi-hole publishes port 53, so Aardvark DNS listens on another port
  aardvarkPort = 5353;

  podmanNetwork = {
    ipv6_enabled = true;
    subnets = [
      { subnet = "10.88.0.0/16"; gateway = "10.88.0.1"; }
      { subnet = "fd00::/64"; gateway = "fd00::1"; }
    ];
  };

  microVmNet = {
    bridge = "vm-bridge";
    tapPrefix = "vm-tap-";
    v4 = rec {
      base = "10.77.0";
      prefixLength = 24;
      host = "${base}.1";
      hostCidr = "${host}/${toString prefixLength}";
      guestCidr = index: "${base}.${toString index}/${toString prefixLength}";
    };
    v6 = rec {
      base = "fd77::";
      prefixLength = 64;
      host = "${base}1";
      hostCidr = "${host}/${toString prefixLength}";
      guestCidr = index: "${base}${toString index}/${toString prefixLength}";
    };
  };
in
{
  imports = [
    ./forgejo.nix
    (import ./forgejo-runner.nix { inherit podmanNetwork microVmNet; })
  ];

  boot.kernelModules = [ "vhost_net" ];

  systemd.network = {
    networks."10-wan".matchConfig.Name = wan;

    netdevs."20-${microVmNet.bridge}".netdevConfig = {
      Kind = "bridge";
      Name = microVmNet.bridge;
    };

    networks."20-${microVmNet.bridge}" = {
      matchConfig.Name = microVmNet.bridge;
      address = [
        microVmNet.v4.hostCidr
        microVmNet.v6.hostCidr
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
      # The bridge has no carrier until a VM attaches
      linkConfig.RequiredForOnline = "no";
    };

    networks."21-microvm-taps" = {
      matchConfig.Name = "${microVmNet.tapPrefix}*";
      networkConfig.Bridge = microVmNet.bridge;
    };
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = wan;
    internalInterfaces = [ microVmNet.bridge ];
  };

  virtualisation.podman.defaultNetwork.settings = podmanNetwork // {
    dns_enabled = true;
  };

  virtualisation.containers.containersConf.settings.network.dns_bind_port = aardvarkPort;

  # Containers must reach Aardvark DNS on the host
  networking.firewall.interfaces.podman0 = {
    allowedUDPPorts = [ aardvarkPort ];
    allowedTCPPorts = [ aardvarkPort ];
  };
}
```

All containers share podman's default network, which is dual stack. Published ports are dual stack by default, and containers reach each other by name through Aardvark DNS. Aardvark listens on `aardvarkPort` because Pi-hole publishes port 53. The NixOS podman module only opens UDP 53 on `podman0`, so the firewall rule opens the Aardvark port on that interface.

The microVM bridge is separate from the LAN. The host holds the gateway address on it, every tap whose name starts with `tapPrefix` attaches to it automatically, and NAT sends the VMs' traffic out `wan`. blahaj's NIC configuration is otherwise unchanged.

## Runner VM (`forgejo-runner.nix`)

`services.forgejo-runner` exists only in nixpkgs-unstable, so the VM gets its own unstable package set. The host stays on stable. The host decrypts the VM's secrets with agenix and shares them into the VM read-only, so the guest needs no age key. The module is a function of the values `configuration.nix` passes in.

```nix
{ podmanNetwork, microVmNet }:
{ microvm, nixpkgs-unstable, ... }:
let
  index = 2;
  vcpu = 2;
  mem = 3072;
  tap = "${microVmNet.tapPrefix}micro01";
  secretsDir = "/run/runner-secrets";
  guestSecretsDir = "/run/secrets";
  tokenSecret = "forgejo-runner-token";
  beszelSecret = "runner-beszel-agent";
  instance = "forgejo";
in
{
  age.secrets = {
    ${tokenSecret} = {
      file = ../../secrets/${tokenSecret}.age;
      path = "${secretsDir}/${tokenSecret}";
      symlink = false;
    };
    ${beszelSecret} = {
      file = ../../secrets/${beszelSecret}.age;
      path = "${secretsDir}/${beszelSecret}";
      symlink = false;
    };
  };

  microvm.vms.forgejo-runner = {
    autostart = true;
    pkgs = import nixpkgs-unstable {
      system = "x86_64-linux";
      overlays = [ microvm.overlays.default ];
    };
    config =
      { pkgs, ... }:
      {
        microvm = {
          hypervisor = "qemu";
          inherit vcpu mem;
          balloon = true;
          shares = [
            {
              proto = "virtiofs";
              tag = "ro-store";
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
            }
            {
              proto = "virtiofs";
              tag = "secrets";
              source = secretsDir;
              mountPoint = guestSecretsDir;
              readOnly = true;
            }
          ];
          interfaces = [
            {
              type = "tap";
              id = tap;
              mac = "02:00:00:00:00:14";
              tap.vhost = true;
            }
          ];
        };

        systemd.network.networks."20-uplink" = {
          matchConfig = {
            Kind = "!*";
            Type = "ether";
          };
          address = [
            (microVmNet.v4.guestCidr index)
            (microVmNet.v6.guestCidr index)
          ];
          gateway = [
            microVmNet.v4.host
            microVmNet.v6.host
          ];
        };

        networking.nameservers = [
          microVmNet.v6.host
          microVmNet.v4.host
        ];

        security.pki.certificateFiles = [ ../../static/rcd-rootCA-pub.pem ];

        virtualisation.podman = {
          enable = true;
          dockerSocket.enable = true;
          defaultNetwork.settings = podmanNetwork;
        };

        services.forgejo-runner.instances.${instance} = {
          enable = true;
          runtimes.podman = true;
          hostPackages = with pkgs; [ bash coreutils curl gawk gnused nodejs wget podman ];
          settings = {
            runner = {
              capacity = 1;
              labels = [ "node:host" ];
            };
            server.connections.${instance} = {
              url = "https://git.megaparsec.ca";
              uuid = "00000000-0000-0000-0000-000000000000";
            };
          };
          secrets.server.connections.${instance}.token_url = "${guestSecretsDir}/${tokenSecret}";
        };

        systemd.services."forgejo-runner-${instance}".environment.CONTAINER_HOST = "unix:///run/podman/podman.sock";

        services.beszel.agent = {
          enable = true;
          environment = {
            HUB_URL = "https://monitor.megaparsec.ca";
            SKIP_GPU = true;
          };
          environmentFile = "${guestSecretsDir}/${beszelSecret}";
        };
      };
  };
}
```

Steps run directly in the VM, so there are no job containers. The label needs an explicit scheme, because the runner module treats a bare `node` as neither host nor docker. The VM trusts your root CA system-wide, and `podman` in `hostPackages` plus `CONTAINER_HOST` lets `podman build` use the VM's rootful podman. Build containers talk to the internet, so the guest's own podman network is dual stack too.

The `Kind = "!*"` match keeps podman's veth interfaces inside the VM out of networkd's hands. Pi-hole answers on the host's bridge address, so the VM resolves `git.megaparsec.ca` and every internal name the same way the LAN does.

The Beszel env file holds `KEY=...` and `TOKEN=...` from the hub. Both secrets, `forgejo-runner-token.age` and `runner-beszel-agent.age`, are encrypted to blahaj's host key in `secrets/agenix-rules.nix`.

A second microVM is another module like this one. It needs its own `index`, a tap named with `tapPrefix`, a unique MAC and the same `microVmNet` argument. The host needs no changes.

## Remaining work

1. Create the runner token in Forgejo and the Beszel key and token in the hub. Write `forgejo-runner-token.age` and `runner-beszel-agent.age` with `agenix -e`, then `git add` both.
2. Uncomment the runner import in `configuration.nix` and redeploy.
3. From the guest, check `dig` against the host's bridge addresses for `git.megaparsec.ca`, `curl -6` and `curl -4` against `https://git.megaparsec.ca`, and that the VM reaches the internet over both families. If DNS or HTTPS is blocked, open the ports on the bridge with `networking.firewall.interfaces.${microVmNet.bridge} = { allowedTCPPorts = [ 53 443 ]; allowedUDPPorts = [ 53 ]; };`.
4. From a container in the guest (`podman run --rm <image> curl -6 ...` and `curl -4 ...`), check the full path over both families: build container, guest podman bridge, guest, the microVM bridge's NAT, internet.
5. Register the runner, put its uuid in the module, then run a job that clones a repo and one that runs `podman build`.
6. Update caddy.md, beszel.md and services.md.

## Links

- [Forgejo Docker installation](https://forgejo.org/docs/latest/admin/installation/docker/)
- [Forgejo Actions runner registration](https://forgejo.org/docs/latest/admin/actions/registration/)
- [microvm.nix](https://github.com/microvm-nix/microvm.nix)
