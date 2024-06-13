{ pkgs }: {
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  # Install gcc to compile tree-sitter grammars
  extraPackages = with pkgs; [ gcc ];
}
