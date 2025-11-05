{
  description = "AtomicMegaNerd's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      catppuccin,
      nix-darwin,
      flake-utils,
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
        };

      buildOsConf =
        system: hostname: useStable:
        nixpkgs.lib.nixosSystem {
          pkgs = if useStable then buildPkgsConf system nixpkgs else buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };

      buildHomeMgrConf =
        system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeModules.catppuccin
          ];
        };

      buildDarwinConf =
        system: hostname:
        nix-darwin.lib.darwinSystem {
          system = system;
          pkgs = buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/darwin.nix
          ];
        };

      # This installs the tooling required for managing
      # our dotfiles repos. We need tooling for lua
      # to work on our neovim config, we also need
      # the Haskell toolchain to enable pre-commit
      # hooks for nixfmt
      devShells = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShells = {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                cabal-install
                ghc
                stylua
                lua-language-server
                bash-language-server
              ];
            };
          };
        }
      );

    in
    {
      nixosConfigurations = {
        blahaj = buildOsConf systems.linux "blahaj" true;
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf systems.linux "blahaj";
        "rcd@Schooner" = buildHomeMgrConf systems.darwin "Schooner";
      };

      darwinConfigurations = {
        Schooner = buildDarwinConf systems.darwin "Schooner";
      };

      devShells = devShells.devShells;
    };
}
