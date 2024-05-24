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
      sysLinux = "x86_64-linux";
      sysMac = "aarch64-darwin";

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
        blahaj = nixos sysLinux "blahaj";
        metropolitan = nixos sysLinux "metropolitan";
      };

      homeConfigurations = {
        "rcd@blahaj" = hm sysLinux "blahaj";
        "rcd@metropolitan" = hm sysLinux "metropolitan";
        "rcd@Discovery" = hm sysMac "discovery";
      };
    };
}
