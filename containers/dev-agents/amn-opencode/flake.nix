{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      tools = with pkgs; [
        git
        gh
        fd
        ripgrep
        bat
        oxfmt
        oxlint
        markdownlint-cli2
        yamllint
        jq
        tree
        shellcheck
        shfmt
        nixfmt
        ast-grep
      ];
    in
    {
      packages.aarch64-linux = {
        default = pkgs.buildEnv {
          name = "amn-base";
          paths = tools;
        };
        opencode = pkgs.opencode;
      };
    };
}
