{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
    # Note that we use nixpkgs (stable) for the core NixOS packages but nixpkgs-unstable
    # for everything else (home-manager and nix-darwin). This is intentional. The core OS
    # for my server can be more stable but I want all my development tools to be current.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      agenix,
      catppuccin,
      stylix,
      git-hooks,
      ...
    }:
    let

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # This is for building NixOS configurations, where we are running the full NixOS Linux
      # distribution
      buildNixOS =
        hostname:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/${hostname}/configuration.nix
            agenix.nixosModules.default
          ];
        };

      # This is for building Home Manager configurations which are used on all of our Nix systems
      buildHomeMgr =
        system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.${system};
          modules = [
            ./hosts/${hostname}/rcd.nix
            ./nix/options.nix
            catppuccin.homeModules.catppuccin
            stylix.homeModules.stylix
            agenix.homeManagerModules.default
            { home.packages = [ agenix.packages.${system}.default ]; }
          ];
        };

      # This is for building nix-darwin configurations, which are used to manage macOS systems
      buildDarwinConf =
        hostname:
        nix-darwin.lib.darwinSystem {
          pkgs = nixpkgs-unstable.legacyPackages.${"aarch64-darwin"};
          modules = [
            ./hosts/${hostname}/darwin.nix
          ];
        };

    in
    {
      nixosConfigurations = {
        blahaj = buildNixOS "blahaj";
      };

      darwinConfigurations = {
        Schooner = buildDarwinConf "Schooner";
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgr "x86_64-linux" "blahaj";
        "rcd@Schooner" = buildHomeMgr "aarch64-darwin" "Schooner";
      };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs-unstable.legacyPackages.${system};
        in
        {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              yaml-lint = {
                enable = true;
                name = "yaml lint";
                entry = "${pkgs.yamllint}/bin/yamllint --strict";
                language = "system";
                types = [ "yaml" ];
              };
              md-lint = {
                enable = true;
                name = "markdown lint";
                entry = "${pkgs.markdownlint-cli2}/bin/markdownlint-cli2";
                language = "system";
                types = [ "markdown" ];
              };
              md-format = {
                enable = true;
                name = "markdown format";
                entry = "${pkgs.oxfmt}/bin/oxfmt";
                language = "system";
                types = [ "markdown" ];
              };
            };
          };
        }
        // nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
          nixos-blahaj = self.nixosConfigurations.blahaj.config.system.build.toplevel;
          home-rcd-blahaj = self.homeConfigurations."rcd@blahaj".activationPackage;
        }
        // nixpkgs.lib.optionalAttrs (system == "aarch64-darwin") {
          darwin-Schooner = self.darwinConfigurations.Schooner.config.system.build.toplevel;
          home-rcd-Schooner = self.homeConfigurations."rcd@Schooner".activationPackage;
        }
      );

      devShells = forAllSystems (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
            inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
          in
          pkgs.mkShell {
            inherit shellHook;
            packages = enabledPackages;
          };
      });
    };
}
