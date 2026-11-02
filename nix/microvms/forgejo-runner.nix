{
  pkgs,
  microVmNet,
  podmanNetwork,
  runner ? { },
  ...
}:
let
  runnerConfig = {
    vcpu = 2;
    mem = 3072;
    secretsDir = "/run/runner-secrets";
    guestSecretsDir = "/run/secrets";
    tokenSecret = "forgejo-runner-token";
    beszelSecret = "runner-beszel-agent";
    instance = "forgejo";
    forgejoUrl = "https://git.megaparsec.ca";
    beszelHubUrl = "https://monitor.megaparsec.ca";
  }
  // runner;
  tap = "${microVmNet.tapPrefix}${runnerConfig.tapName}";
  tokenPath = "${runnerConfig.guestSecretsDir}/${runnerConfig.tokenSecret}";
  beszelPath = "${runnerConfig.guestSecretsDir}/${runnerConfig.beszelSecret}";
in
{
  system.stateVersion = "26.05";

  microvm = {
    hypervisor = "qemu";
    inherit (runnerConfig) vcpu mem;
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
        source = runnerConfig.secretsDir;
        mountPoint = runnerConfig.guestSecretsDir;
        readOnly = true;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = tap;
        mac = runnerConfig.mac;
        tap.vhost = true;
      }
    ];
  };

  systemd.network.networks."20-uplink" = {
    # Kind "!*" leaves podman's veth interfaces alone
    matchConfig = {
      Kind = "!*";
      Type = "ether";
    };
    address = [
      (microVmNet.v4.guestCidr runnerConfig.index)
      (microVmNet.v6.guestCidr runnerConfig.index)
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

  services.forgejo-runner.instances.${runnerConfig.instance} = {
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
      server.connections.${runnerConfig.instance} = {
        url = runnerConfig.forgejoUrl;
        uuid = runnerConfig.runnerUuid;
      };
    };
    secrets.server.connections.${runnerConfig.instance}.token_url = tokenPath;
  };

  systemd.services."forgejo-runner-${runnerConfig.instance}".environment.CONTAINER_HOST =
    "unix:///run/podman/podman.sock";

  services.beszel.agent = {
    enable = true;
    environment = {
      HUB_URL = runnerConfig.beszelHubUrl;
      SKIP_GPU = true;
      SERVICE_PATTERNS = "forgejo-runner-*,podman*";
    };
    environmentFile = beszelPath;
  };
}
