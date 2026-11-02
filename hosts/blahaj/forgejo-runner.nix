let
  runner = {
    index = 2;
    tapName = "micro01";
    mac = "02:00:00:00:00:14";
    runnerUuid = "5ba7684b-abf6-4ac0-adac-db0e28fa5a1a";
  };
in
{
  age.secrets = {
    forgejo-runner-token = {
      file = ../../secrets/forgejo-runner-token.age;
      path = "/run/runner-secrets/forgejo-runner-token";
      symlink = false;
    };
    runner-beszel-agent = {
      file = ../../secrets/runner-beszel-agent.age;
      path = "/run/runner-secrets/runner-beszel-agent";
      symlink = false;
    };
  };

  microvm.vms.forgejo-runner = {
    autostart = true;
    specialArgs = {
      inherit runner;
      inherit (import ./blahaj-network.nix) microVmNet podmanNetwork;
    };
    config = import ../../nix/microvms/forgejo-runner.nix;
  };
}
