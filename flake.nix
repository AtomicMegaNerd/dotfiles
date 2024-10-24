{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = { url = "github:catppuccin/nix"; };
    atuin = { url = "github:atuinsh/atuin"; };
  };

  outputs =
    { self, nixos, nixpkgs, home-manager, catppuccin, nixos-wsl, atuin }:
    let
      sysLinux = "x86_64-linux";
      sysMac = "aarch64-darwin";

      buildPkgsConf = system: isNixos:
        import (if isNixos then nixos else nixpkgs) {
          inherit system;
          config.allowUnfree = true;
        };

      buildNixOsConf = system: hostname: isWsl:
        nixos.lib.nixosSystem {
          pkgs = buildPkgsConf system true;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ] ++ (if isWsl then [ nixos-wsl.nixosModules.wsl ] else [ ]);
        };

      buildHomeMgrConf = system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system false;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeManagerModules.catppuccin
            { home.packages = [ atuin.packages.${system}.default ]; }
          ];
        };

    in {
      nixosConfigurations = {
        blahaj = buildNixOsConf sysLinux "blahaj" false;
        metropolitan = buildNixOsConf sysLinux "metropolitan" true;
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf sysLinux "blahaj";
        "rcd@Discovery" = buildHomeMgrConf sysMac "discovery";
        "rcd@metropolitan" = buildHomeMgrConf sysLinux "metropolitan";
      };
    };
}
