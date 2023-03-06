{ pkgs }:
{
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  extraPackages = with pkgs; [
    # Language servers
    sumneko-lua-language-server
    rnix-lsp

    # null-ls sources
    shellcheck
    stylua
    nixpkgs-fmt
    nodePackages.markdownlint-cli
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    nodePackages.prettier
  ];

  plugins = with pkgs.vimPlugins;
    let
      nvim-transparent = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-transparent";
        src = pkgs.fetchFromGitHub {
          owner = "xiyaowong";
          repo = "nvim-transparent";
          rev = "6816751e3d595b3209aa475a83b6fbaa3a5ccc98";
          sha256 = "sha256-j1PO0r2q5w0fJvO7BG0xXDjIdOVl73eGO1rclB221uw=";
        };
      };
    in
    [
      nvim-transparent
      (nvim-treesitter.withPlugins (p:
        [
          p.nix
          p.go
          p.rust
          p.haskell
          p.python
          p.typescript
          p.fish
          p.bash
          p.markdown
          p.yaml
          p.toml
        ])
      )
      alpha-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      nightfox-nvim
      gitsigns-nvim
      nvim-lspconfig
      null-ls-nvim
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
      rust-tools-nvim
      comment-nvim
      todo-comments-nvim
      vim-eunuch
      vim-fugitive
      vim-test
      vim-rooter
      toggleterm-nvim
    ];
}
