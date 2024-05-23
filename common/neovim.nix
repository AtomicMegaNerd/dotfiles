{ pkgs }:
let
  myNixpkgs = pkgs.appendOverlays [
    (self: super: {
      vimPlugins = super.vimPlugins // {
        CopilotChat-nvim = super.vimUtils.buildVimPlugin {
          pname = "CopilotChat-nvim";
          version = "master";
          src = super.fetchFromGitHub {
            owner = "CopilotC-Nvim";
            repo = "CopilotChat.nvim";
            rev = "master";
            sha256 = "0lrhwq7jb4irz9nsz487ximcgmr0bg6bx6v0hwslnr4sl5vgx5ld";
          };
        };
      };
    })
  ];
in {
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  extraPackages = with myNixpkgs; [
    # Language servers
    lua-language-server
    shellcheck
    stylua
    tree-sitter
    haskellPackages.nixfmt
    nil
    nodePackages.markdownlint-cli
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    nodePackages.prettier
  ];

  plugins = with myNixpkgs.vimPlugins; [
    # Treesitter
    (nvim-treesitter.withAllGrammars)
    # Theme
    catppuccin-nvim
    nvim-notify
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
    # Misc
    todo-comments-nvim
    conform-nvim
    fidget-nvim
    which-key-nvim
    # Dependencies
    nvim-web-devicons
    plenary-nvim
    copilot-vim
    vim-test
    oil-nvim
    CopilotChat-nvim # Add the CopilotChat.nvim plugin here
  ];
}
