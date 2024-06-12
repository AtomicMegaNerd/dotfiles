{ pkgs }: {
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  extraPackages = with pkgs; [
    # Language servers
    lua-language-server
    shellcheck
    stylua
    tree-sitter
    haskellPackages.nixfmt
    nixd
    nodePackages.markdownlint-cli
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    nodePackages.prettier
  ];

  plugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (p: [
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
      p.hyprlang
    ]))
    # Core deps
    nvim-web-devicons
    plenary-nvim
    nvim-notify
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
    neogit
    diffview-nvim
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
    # Bots
    CopilotChat-nvim
    copilot-vim
    # Misc
    vim-test
    oil-nvim
    todo-comments-nvim
    conform-nvim
    fidget-nvim
  ];
}
