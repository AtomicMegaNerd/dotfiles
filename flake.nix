{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
    # Note that we use nixpkgs (stable) for the core NixOS packages but nixpkgs-unstable
    # for everything else (home-manager and nix-darwin). This is intentional.
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
    }:
    let
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
            catppuccin.homeModules.catppuccin
            agenix.homeManagerModules.default
            # TODO: Fix this once we are ready to move to the dendritic pattern
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
    };
}
