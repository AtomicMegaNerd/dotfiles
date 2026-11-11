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
        nodejs
        bun
      ];
    in
    {
      packages.aarch64-linux = {
        default = pkgs.buildEnv {
          name = "amn-claude";
          paths = tools ++ [ pkgs.claude-code ];
        };
      };
    };
}
