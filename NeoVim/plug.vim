call plug#begin('~/.config/nvim/plugged')

" Helpers
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-rooter'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'kamykn/spelunker.vim'
Plug 'kamykn/popup-menu.nvim'
Plug 'godlygeek/tabular'
Plug 'dag/vim-fish'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-eunuch'
Plug 'vim-test/vim-test'

" GUI
Plug 'itchyny/lightline.vim'

" Theming
Plug 'gruvbox-community/gruvbox'

" Code formatting
Plug 'psf/black', { 'tag': 'stable' }

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat'}
Plug 'plasticboy/vim-markdown'

Plug 'neovim/nvim-lspconfig'

" Initialize plugin system
call plug#end()

