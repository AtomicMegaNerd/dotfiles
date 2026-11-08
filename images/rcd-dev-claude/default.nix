{
  pkgs,
  nix2container,
  nixosSystem,
}:
let
  version = "0.1.0";
  caBundle = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  os =
    (nixosSystem {
      modules = [
        (
          { pkgs, modulesPath, ... }:
          {
            imports = [
              "${modulesPath}/profiles/minimal.nix"
            ];

            nixpkgs = {
              hostPlatform = "aarch64-linux";
              config.allowUnfree = true;
            };

            boot.isContainer = true;
            system.stateVersion = "26.05";
            system.disableInstallerTools = true;

            nix.settings = {
              experimental-features = [
                "nix-command"
                "flakes"
              ];
              build-users-group = "";
              ssl-cert-file = caBundle;
            };

            programs.git = {
              enable = true;
            };

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

  claudeConfig = pkgs.linkFarm "rcd-dev-claude-config" [
    {
      name = "etc/nix/nix.conf";
      path = os.environment.etc."nix/nix.conf".source;
    }
    {
      name = "root/.claude/CLAUDE.md";
      path = ../../static/claude-code/CLAUDE.md;
    }
    {
      name = "root/.claude/settings.json";
      path = ../../static/claude-code/settings.json;
    }
    {
      name = "root/.claude/agents/rcd-go.md";
      path = ../../static/agents/rcd-go.md;
    }
    {
      name = "root/.claude/agents/rcd-nix.md";
      path = ../../static/agents/rcd-nix.md;
    }
  ];
in
nix2container.buildImage {
  name = "git.megaparsec.ca/atomicmeganerd/rcd-dev-claude";
  tag = version;

  copyToRoot = [
    (pkgs.buildEnv {
      name = "rcd-dev-claude-env";
      paths = [
        os.system.path
        pkgs.dockerTools.fakeNss
      ];
      pathsToLink = [
        "/bin"
        "/etc"
      ];
    })
    claudeConfig
  ];

  config = {
    Entrypoint = [
      "/bin/nix"
      "develop"
      "--command"
      "claude"
    ];
    WorkingDir = "/work/project";
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
