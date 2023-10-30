{
  description = "AtomicMegaNerd Core Nix Flake";

  inputs = {
    # NixOS stable and unstable sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager sources
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager }:
    let
      pkgs-linux = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      unstable-linux = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      unstable-mac = import nixpkgs-unstable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    in
    {

      # Nix OS core configuration
      nixosConfigurations = {
        blahaj = nixpkgs.lib.nixosSystem {
          pkgs = pkgs-linux;
          system = "x86_64-linux";
          modules = [
            ./hosts/blahaj/configuration.nix
          ];
        };
        metropolitan = nixpkgs.lib.nixosSystem {
          pkgs = pkgs-linux;
          system = "x86_64-linux";
          modules = [
            ./hosts/metropolitan/configuration.nix
            nixos-wsl.nixosModules.wsl
          ];
        };
      };

      # Home Manager configuration
      homeConfigurations = {
        useGlobalPkgs = true;
        useUserPackages = true;
        # Blahaj
        "rcd@blahaj" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable-linux;
          modules = [ ./hosts/blahaj/rcd.nix ];
        };
        "root@blahaj" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable-linux;
          modules = [ ./hosts/blahaj/root.nix ];
        };
        # Discovery
        "rcd@Discovery" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable-mac;
          modules = [ ./hosts/discovery/rcd.nix ];
        };
        # Metropolitan
        "rcd@metropolitan" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable-linux;
          modules = [ ./hosts/metropolitan/rcd.nix ];
        };
        "root@metropolitan" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable-linux;
          modules = [ ./hosts/metropolitan/root.nix ];
        };
      };
    };
}
