#     ___   __                  _      __  ___                 _   __              __
#    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
#   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
#  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
# /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
#                                              /____/
#
# Nix Flake

{
  description = "AtomicMegaNerd's NixOS Flake";
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
      inputs.nixpkgs.follows = "nixos";
    };
  };

  outputs = { self, nixos, nixpkgs, home-manager, catppuccin, nixos-wsl }:
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
          ];
        };
    in
    {
      nixosConfigurations = {
        blahaj = buildNixOsConf sysLinux "blahaj" false;
        metropolitan = buildNixOsConf sysLinux "metropolitan" true;
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf sysLinux "blahaj";
        "rcd@metropolitan" = buildHomeMgrConf sysLinux "metropolitan";
        "rcd@Discovery" = buildHomeMgrConf sysMac "discovery";
      };
    };
}
