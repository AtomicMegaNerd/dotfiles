{
  pkgs,
  nix2container,
  nixosSystem,
}:
let
  version = "0.1.0";
  os =
    (nixosSystem {
      modules = [
        (
          { pkgs, ... }:
          {
            nixpkgs = {
              hostPlatform = "aarch64-linux";
              config.allowUnfree = true;
            };

            boot.isContainer = true;
            system.stateVersion = "26.05";

            users.users.agent = {
              isNormalUser = true;
              uid = 1000;
              home = "/work";
              createHome = true;
            };

            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];

            programs.git.enable = true;

            environment.systemPackages = with pkgs; [
              claude-code
              uutils-coreutils-noprefix
              fd
              ripgrep
              bat
            ];
          }
        )
      ];
    }).config;
in
nix2container.buildImage {
  name = "git.megaparsec.ca/atomicmeganerd/rcd-dev-claude";
  tag = version;

  copyToRoot = [
    (pkgs.buildEnv {
      name = "shim";
      paths = with pkgs; [
        bashInteractive
        uutils-coreutils-noprefix
        dockerTools.fakeNss
      ];
      pathsToLink = [
        "/bin"
        "/etc"
      ];
    })
  ];

  config = {
    Entrypoint = [ "${os.system.build.toplevel}/init" ];
    StopSignal = "SIGRTMIN+3";
    Labels = {
      "org.opencontainers.image.title" = "rcd-dev-claude";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.authors" = "Chris Dunphy";
      "org.opencontainers.image.description" = "AtomicMegaNerd dev container - claude code edition";
      "org.opencontainers.image.licenses" = "MIT";
    };
  };

  initializeNixDatabase = true;
}
