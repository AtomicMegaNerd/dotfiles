{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = { url = "github:catppuccin/nix"; };
  };

  outputs = { self, nixos, nixpkgs, home-manager, catppuccin, }:
    let
      sysLinux = "x86_64-linux";
      sysMac = "aarch64-darwin";

      buildPkgsConf = system: isNixos:
        import (if isNixos then nixos else nixpkgs) {
          inherit system;
          config.allowUnfree = true;
        };

      buildNixOsConf = system: hostname:
        nixos.lib.nixosSystem {
          pkgs = buildPkgsConf system true;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };

      buildHomeMgrConf = system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system false;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };

    in {
      nixosConfigurations = {
        blahaj = buildNixOsConf sysLinux "blahaj";
        metropolitan-nixos-01 = buildNixOsConf sysLinux "metropolitan-nixos-01";
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf sysLinux "blahaj";
        "rcd@Discovery" = buildHomeMgrConf sysMac "discovery";
        "rcd@metropolitan-nixos-01" = buildHomeMgrConf sysLinux "metropolitan-nixos-01";
      };
    };
}
