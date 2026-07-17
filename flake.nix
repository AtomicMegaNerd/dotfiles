{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
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
      # We can add additional system types later if we start using more
      linuxX64 = "x86_64-linux";
      macos = "aarch64-darwin";

      # This is for building NixOS configurations, where we are running the full NixOS Linux
      # distribution
      buildNixOS =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = linuxX64;
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
            { home.packages = [ agenix.packages.${system}.default ]; }
          ];
        };

      # This is for building nix-darwin configurations, which are used to manage macOS systems
      buildDarwinConf =
        hostname:
        nix-darwin.lib.darwinSystem {
          pkgs = nixpkgs-unstable.legacyPackages.${macos};
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
        "rcd@blahaj" = buildHomeMgr linuxX64 "blahaj";
        "rcd@Schooner" = buildHomeMgr macos "Schooner";
      };
    };
}
