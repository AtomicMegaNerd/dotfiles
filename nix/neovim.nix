{ pkgs }: {
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  plugins = with pkgs.vimPlugins;
    [
      nvim-treesitter.withAllGrammars
    ];
}
