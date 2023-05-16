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
          rev = "ae46ff104269f031a0656672106f2ab8f6abf585";
          sha256 = "sha256-VOaIb07HRK+ZKArPCWr2HVBQLjxnHNEyUhAybPEcq4I=";
        };
      };
    in
    [
      nvim-transparent
      (nvim-treesitter.withPlugins (p:
        [
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
      vim-rooter
      toggleterm-nvim
      lsp_signature-nvim
      refactoring-nvim
      neotest
      FixCursorHold-nvim
      neotest-python
      neotest-go
      neotest-rust
      neotest-haskell
    ];
}
