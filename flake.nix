{
  description = "AtomicMegaNerd's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; };

    catppuccin = { url = "github:catppuccin/nix"; };

    ghostty = { url = "github:ghostty-org/ghostty"; };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin
    , nixos-wsl, ghostty }:
    let
      systems = {
        linux = "x86_64-linux";
        darwin = "aarch64-darwin";
      };

      buildPkgsConf = system: nixpkgs:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      buildOsConf = system: hostname: extraModules:
        nixpkgs.lib.nixosSystem {
          pkgs = buildPkgsConf system nixpkgs;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ] ++ extraModules;
        };

      buildHomeMgrConf = system: hostname:
        home-manager.lib.homeManagerConfiguration {
          # Use unstable for home-manager
          pkgs = buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/rcd.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };

    in {
      nixosConfigurations = {
        blahaj = buildOsConf systems.linux "blahaj" [ ];
        arcology = buildOsConf systems.linux "arcology" [{
          environment.systemPackages =
            [ ghostty.packages.${systems.linux}.default ];
        }];
        metropolitan = buildOsConf systems.linux "metropolitan"
          [ nixos-wsl.nixosModules.wsl ];
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf systems.linux "blahaj";
        "rcd@Discovery" = buildHomeMgrConf systems.darwin "Discovery";
      };
    };
}
