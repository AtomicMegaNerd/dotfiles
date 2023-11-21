{ pkgs }:
{
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  extraPackages = with pkgs; [
    # Language servers
    lua-language-server
    rnix-lsp
    shellcheck
    rust-analyzer
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
      alpha-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      gitsigns-nvim
      nvim-lspconfig
      fidget-nvim
      nvim-cmp
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      lspkind-nvim
      lualine-nvim
      nvim-web-devicons
      plenary-nvim
      comment-nvim
      todo-comments-nvim
      vim-eunuch
      vim-fugitive
      vim-rooter
      vim-test
      lsp_signature-nvim
      nvim-lint
      formatter-nvim
      catppuccin-nvim
      neodev-nvim
    ];
}
