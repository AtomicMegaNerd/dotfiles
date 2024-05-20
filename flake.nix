{
  description = "AtomicMegaNerd Core Nix Flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, home-manager, nixos-wsl }:
    let
      system-linux = "x86_64-linux";
      system-mac = "aarch64-darwin";
      unstable = system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
    in {
      nixosConfigurations = {
        blahaj = nixpkgs-unstable.lib.nixosSystem {
          pkgs = unstable system-linux;
          modules = [ ./hosts/blahaj/configuration.nix ];
        };
        metropolitan = nixpkgs-unstable.lib.nixosSystem {
          pkgs = unstable system-linux;
          modules = [ 
	    ./hosts/metropolitan/configuration.nix
	    nixos-wsl.nixosModules.wsl
	  ];
        };
      };

      homeConfigurations = {
        "rcd@blahaj" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable system-linux;
          modules = [ ./hosts/blahaj/rcd.nix ];
        };
        "rcd@Discovery" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable system-mac;
          modules = [ ./hosts/discovery/rcd.nix ];
        };
        "rcd@metropolitan" = home-manager.lib.homeManagerConfiguration {
          pkgs = unstable system-linux;
          modules = [ ./hosts/metropolitan/rcd.nix ];
        };
      };
    };

}
