{ pkgs }:
{
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  extraPackages = with pkgs; [
    # Language servers
    # TODO: Re-enable this once it is no longer broken on the Mac
    lua-language-server
    rnix-lsp
    shellcheck
    stylua
    tree-sitter
    nixpkgs-fmt
    nodePackages.markdownlint-cli
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    nodePackages.prettier
  ];

  plugins = with pkgs.vimPlugins;
    [
      # Treesitter
      (nvim-treesitter.withPlugins (p:
        [
          p.c
          p.lua
          p.nix
          p.go
          p.gomod
          p.rust
          p.haskell
          p.python
          p.typescript
          p.fish
          p.bash
          p.markdown
          p.yaml
          p.toml
          p.zig
        ])
      )
      # Theme
      catppuccin-nvim
      # Status Screen
      alpha-nvim
      # Telescope
      telescope-nvim
      telescope-ui-select-nvim
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      # Git
      vim-fugitive
      gitsigns-nvim
      # LSP
      nvim-lspconfig
      neodev-nvim
      lsp_signature-nvim
      # Completion
      nvim-cmp
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      lspkind-nvim
      # Status Line
      lualine-nvim
      # Comments
      comment-nvim
      todo-comments-nvim
      # Misc
      vim-rooter
      vim-test
      formatter-nvim
      fidget-nvim
      which-key-nvim
      # Dependencies
      nvim-web-devicons
      plenary-nvim
    ];
}
