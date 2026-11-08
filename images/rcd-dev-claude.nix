{
  pkgs,
  buildImage,
  nixosSystem,
}:
let
  version = "0.1.0";

  workDir = pkgs.writeTextDir "work/.keep" "";

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

            nix = {
              nrBuildUsers = 0;
              settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                build-users-group = "";
                sandbox = false;
              };
            };

            programs.git.enable = true;

            environment = {
              corePackages = [ ];
              defaultPackages = [ ];
              systemPackages = with pkgs; [
                claude-code
                bashInteractive
                uutils-coreutils-noprefix
                fd
                ripgrep
                bat
              ];
            };
          }
        )
      ];
    }).config;
in
buildImage {
  name = "git.megaparsec.ca/atomicmeganerd/rcd-dev-claude";
  tag = version;

  config = {
    User = "1000:1000";
    WorkingDir = "/work/project";
    Labels = {
      "org.opencontainers.image.title" = "rcd-dev-claude";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.authors" = "Chris Dunphy";
      "org.opencontainers.image.description" = "AtomicMegaNerd dev container - claude code edition";
      "org.opencontainers.image.licenses" = "MIT";
    };
    Cmd = [ "/bin/${pkgs.claude-code.meta.mainProgram}" ];
    Env = [
      "PATH=/bin"
      "HOME=/work"
      "USER=agent"
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
    ];
  };

  inherit os;

  initializeNixDatabase = true;
  nixUid = 1000;
  nixGid = 1000;

  copyToRoot = [ workDir ];

  perms = [
    {
      path = workDir;
      regex = "/work$";
      mode = "0755";
      uid = 1000;
      gid = 1000;
    }
  ];
}
