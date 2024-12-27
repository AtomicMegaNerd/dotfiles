{
  description = "AtomicMegaNerd's NixOS Flake";

  inputs = {
    # Stable nixpkgs for NixOS configuration
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";

    # Unstable nixpkgs for development tools and Home Manager
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Stable Home Manager release
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Other inputs
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    catppuccin = { url = "github:catppuccin/nix"; };

    atuin = { url = "github:atuinsh/atuin"; };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin
    , nixos-wsl, atuin }:
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
            { home.packages = [ atuin.packages.${system}.default ]; }
          ];
        };

    in {
      nixosConfigurations = {
        blahaj = buildOsConf systems.linux "blahaj" [ ];
        arcology = buildOsConf systems.linux "arcology" [ ];
        metropolitan = buildOsConf systems.linux "metropolitan"
          [ nixos-wsl.nixosModules.wsl ];
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf systems.linux "blahaj";
        "rcd@arcology" = buildHomeMgrConf systems.linux "arcology";
        "rcd@metropolitan" = buildHomeMgrConf systems.linux "metropolitan";
        "rcd@Discovery" = buildHomeMgrConf systems.darwin "Discovery";
      };
    };
}
