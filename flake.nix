{
  description = "AtomicMegaNerd's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      catppuccin,
      nix-darwin,
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

      # This installs the tooling required for managing our dotfiles repos. We need tooling for lua
      # to work on our neovim config, we also need the Haskell toolchain to enable pre-commit
      # hooks for nixfmt
      devShells = nixpkgs.lib.genAttrs (builtins.attrValues systems) (
        system:
        let
          pkgs = buildPkgsConf system nixpkgs-unstable;
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cabal-install
              ghc
              stylua
              lua-language-server
              yaml-language-server
              prettier
            ];
          };
        }
      );
    };
}
