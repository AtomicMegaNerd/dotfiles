{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system-linux = "x86_64-linux";
      system-mac = "aarch64-darwin";

      pkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      nixos = system: hostname:
        nixpkgs.lib.nixosSystem {
          pkgs = pkgs system;
          modules = [ ./hosts/${hostname}/configuration.nix ];
        };

      hm = system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs system;
          modules = [ ./hosts/${hostname}/rcd.nix ];
        };
    in {
      nixosConfigurations = {
        blahaj = nixos system-linux "blahaj";
        metropolitan = nixos system-linux "metropolitan";
      };

      homeConfigurations = {
        "rcd@blahaj" = hm system-linux "blahaj";
        "rcd@Discovery" = hm system-mac "discovery";
        "rcd@metropolitan" = hm system-linux "metropolitan";
      };
    };
}
