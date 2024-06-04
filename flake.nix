{
  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixos, nixpkgs, home-manager, catppuccin, nixos-wsl }:
    let
      sysLinux = "x86_64-linux";
      sysMac = "aarch64-darwin";

      buildOsPkgsConf = system:
        import nixos {
          inherit system;
          config.allowUnfree = true;
        };

      buildPkgsConf = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      buildNixOsConf = system: hostname:
        nixos.lib.nixosSystem {
          pkgs = buildOsPkgsConf system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };

      buildWslNixOsConf = system: hostname:
        nixos.lib.nixosSystem {
          pkgs = buildOsPkgsConf system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
            nixos-wsl.nixosModules.wsl
          ];
        };

      buildHomeMgrConf = system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };
    in
    {
      nixosConfigurations = {
        blahaj = buildNixOsConf sysLinux "blahaj";
        metropolitan = buildWslNixOsConf sysLinux "metropolitan";
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf sysLinux "blahaj";
        "rcd@metropolitan" = buildHomeMgrConf sysLinux "metropolitan";
        "rcd@Discovery" = buildHomeMgrConf sysMac "discovery";
      };
    };
}
