{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    charmbracelet = {
      url = "github:charmbracelet/nur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      catppuccin,
      nix-darwin,
      git-hooks,
      charmbracelet,
    }:
    let
      systems = {
        linux = "x86_64-linux";
        darwin = "aarch64-darwin";
      };

      buildPkgsConf =
        system: pkg_src:
        import pkg_src {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              direnv = prev.direnv.overrideAttrs (_: {
                doCheck = false;
              });
            })
          ];
        };

      # This is for building NixOS configurations, where we are running the full NixOS Linux
      # distribution
      buildOsConf =
        system: hostname:
        nixpkgs.lib.nixosSystem {
          pkgs = buildPkgsConf system nixpkgs;
          modules = [
            ./hosts/${hostname}/configuration.nix
          ];
        };

      buildHomeMgrConf =
        system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeModules.catppuccin
            charmbracelet.homeModules.crush
          ];
        };

      # This is for building nix-darwin configurations, which are used to manage macOS systems
      buildDarwinConf =
        system: hostname:
        nix-darwin.lib.darwinSystem {
          inherit system;
          pkgs = buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/darwin.nix
          ];
        };

      buildPreCommitCheck =
        system:
        git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            oxfmt = {
              enable = true;
              name = "oxfmt";
              entry = "oxfmt .";
              pass_filenames = false;
            };
            trim-trailing-whitespace.enable = true;
            mixed-line-endings.enable = true;
            end-of-file-fixer.enable = true;
            nixfmt.enable = true;
            markdownlint.enable = true;
            flake-checker.enable = true;
          };
        };

    in
    {
      nixosConfigurations = {
        # Blahaj is my Lenovo ThinkCentre server running NixOS.
        blahaj = buildOsConf systems.linux "blahaj";
      };

      darwinConfigurations = {
        # My 13-inch M4 MacBook Air
        Schooner = buildDarwinConf systems.darwin "Schooner";
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf systems.linux "blahaj";
        "rcd@Schooner" = buildHomeMgrConf systems.darwin "Schooner";
      };

      checks = nixpkgs.lib.genAttrs (builtins.attrValues systems) (system: {
        pre-commit-check = buildPreCommitCheck system;
      });

      devShells = nixpkgs.lib.genAttrs (builtins.attrValues systems) (
        system:
        let
          pkgs = buildPkgsConf system nixpkgs-unstable;
        in
        {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            packages = [
              pkgs.nixfmt
              pkgs.nil
              pkgs.oxfmt
              pkgs.yaml-language-server
              pkgs.bash-language-server
            ];
          };
        }
      );
    };
}
