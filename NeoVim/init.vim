set encoding=utf-8

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-easy-align'

" Routing and search
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" GUI
Plug 'itchyny/lightline.vim'

" coc and plug-ins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/coc-rust-analyzer'
Plug 'neoclide/coc-python'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-java'
Plug 'josa42/coc-docker'

" File management
Plug 'preservim/nerdtree'

" Theming
Plug 'chriskempson/base16-vim'

" Code formatting
Plug 'psf/black', { 'tag': '19.10b0' }

" Git
Plug 'tpope/vim-fugitive'

" Syntax highlighting
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'neovimhaskell/haskell-vim'

" Initialize plugin system
call plug#end()

" Configure base16 color plug-in
set termguicolors
let base16colorspace=256
colorscheme base16-bright

" Configure cursor
set guicursor=a:blinkon100

" Enable mouse
set mouse=a

" Turn on the gutter
set number

set autoindent
set expandtab
set tabstop=4
set smarttab

" This disables folding for the markdown plug-in.
let g:vim_markdown_folding_disabled = 1

" Rulers

" Default to 80 cols
set colorcolumn=80

au Filetype rust set colorcolumn=100
" Black likes 88
au Filetype python set colorcolumn=88

" Automatically run black when saving Python files
autocmd BufWritePre *.py execute ':Black'

" ====================
" === Key Bindings ===
" ====================

nmap <C-n> :NERDTreeToggle<CR>
