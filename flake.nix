{
  description = "AtomicMegaNerd's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    catppuccin = { url = "github:catppuccin/nix"; };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin }:
    let
      systems = {
        linux = "x86_64-linux";
        darwin = "aarch64-darwin";
      };

      buildPkgsConf = system: pkg_src:
        import pkg_src {
          inherit system;
          config.allowUnfree = true;
        };

      buildOsConf = system: hostname: extraModules: useStable:
        nixpkgs.lib.nixosSystem {
          pkgs = if useStable then
            buildPkgsConf system nixpkgs
          else
            buildPkgsConf system nixpkgs-unstable;
          modules = [
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
          ] ++ extraModules;
        };

      buildHomeMgrConf = system: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = buildPkgsConf system nixpkgs-unstable;
          modules =
            [ ./hosts/${hostname}/rcd.nix catppuccin.homeModules.catppuccin ];
        };

    in {
      nixosConfigurations = {
        blahaj = buildOsConf systems.linux "blahaj" [ ] true;
      };

      homeConfigurations = {
        "rcd@blahaj" = buildHomeMgrConf systems.linux "blahaj";
        "rcd@Discovery" = buildHomeMgrConf systems.darwin "Discovery";
      };
    };
}
