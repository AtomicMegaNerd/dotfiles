{
  description = "AtomicMegaNerd's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    catppuccin = { url = "github:catppuccin/nix"; };

    atuin = { url = "github:atuinsh/atuin"; };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager
    , home-manager-unstable, catppuccin, nixos-wsl, atuin }:
    let
      sysLinux = "x86_64-linux";
      sysDarwin = "aarch64-darwin";

      buildPkgsConf = system: stable:
        import (if stable then nixpkgs else nixpkgs-unstable) {
          inherit system;
          config.allowUnfree = true;
        };

      buildNixOsConf = system: hostname: stable: isWsl:
        nixpkgs.lib.nixosSystem {
          pkgs = buildPkgsConf system stable;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ] ++ (if isWsl then [ nixos-wsl.nixosModules.wsl ] else [ ]);
        };

      buildHomeMgrConf = system: hostname: stable:
        let hm = if stable then home-manager else home-manager-unstable;
        in hm.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system stable;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeManagerModules.catppuccin
            { home.packages = [ atuin.packages.${system}.default ]; }
          ];
        };

    in {

      nixosConfigurations = {
        blahaj = buildNixOsConf sysLinux "blahaj" true false;
        arcology = buildNixOsConf sysLinux "arcology" true false;
        metropolitan = buildNixOsConf sysLinux "metropolitan" true true;
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf sysLinux "blahaj" true;
        "rcd@arcology" = buildHomeMgrConf sysLinux "arcology" true;
        "rcd@metropolitan" = buildHomeMgrConf sysLinux "metropolitan" true;
      };
    };
}
