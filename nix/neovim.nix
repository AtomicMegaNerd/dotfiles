{ pkgs }:
{
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  # Also include dependencies which are required
  extraPackages = with pkgs; [
    gcc
    tree-sitter
    nodejs-slim_24
  ];
}
