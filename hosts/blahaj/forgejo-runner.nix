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
        system.stateVersion = "26.05";

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
          hostPackages = with pkgs; [
            bash
            coreutils
            curl
            gawk
            gnused
            nodejs
            wget
            podman
          ];
          settings = {
            runner = {
              capacity = 1;
              labels = [ "node:host" ];
            };
            server.connections.${instance} = {
              url = "https://git.megaparsec.ca";
              uuid = "5ba7684b-abf6-4ac0-adac-db0e28fa5a1a";
            };
          };
          secrets.server.connections.${instance}.token_url = "${guestSecretsDir}/${tokenSecret}";
        };

        systemd.services."forgejo-runner-${instance}".environment.CONTAINER_HOST =
          "unix:///run/podman/podman.sock";

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
