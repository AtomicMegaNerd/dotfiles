"     ___   __                  _      __  ___                 _   __              __
"    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
"   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
"  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
" /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
"                                              /____/
" NeoVim Configuration File

set shell=/bin/bash
set encoding=utf-8
<<<<<<< HEAD
set guicursor=a:blinkon100
set colorcolumn=100
=======
set termguicolors
set guicursor=a:blinkon100
>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1
set mouse=a
set hidden
set nowrap
set smartcase
<<<<<<< HEAD
set undodir=~/.vim/undodir
set undofile
set nobackup
set incsearch
set scrolloff=8
set signcolumn=yes
set relativenumber
set nohlsearch
set nu
set noswapfile
=======

set undodir=~/.vim/undodir
set noswapfile
set undofile
set nobackup

set scrolloff=8
set signcolumn=yes
set relativenumber
set colorcolumn=100
set noshowmode
set nu
set nohlsearch
set incsearch

>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
<<<<<<< HEAD
set noshowmode
set termguicolors
=======

>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1

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
Plug 'fannheyward/coc-pyright'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-java'
Plug 'josa42/coc-docker'

" File management
Plug 'preservim/nerdtree'

" Theming
Plug 'chriskempson/base16-vim'
Plug 'gruvbox-community/gruvbox'

" Code formatting
Plug 'psf/black', { 'tag': '19.10b0' }
<<<<<<< HEAD

=======
Plug 'sdiehl/vim-ormolu'
>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1
" Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
<<<<<<< HEAD
Plug 'tpope/vim-rhubarb'
=======
Plug 'mhinz/vim-signify'
>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
<<<<<<< HEAD
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'hashivim/vim-terraform'
=======
Plug 'neovimhaskell/haskell-vim'
>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1

" Initialize plugin system
call plug#end()

" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status',
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Configure base16 color plug-in
<<<<<<< HEAD
let base16colorspace=256
colorscheme base16-default-dark

=======
>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1
filetype plugin indent on

" This disables folding for the markdown plug-in.
let g:vim_markdown_folding_disabled = 1

<<<<<<< HEAD
let g:terraform_fmt_on_save=1
let g:terraform_align=1
=======
let base16colorspace=256
colorscheme gruvbox
>>>>>>> efb4648649a1b0553da42d63efcab76371ceaef1

" Rust
au Filetype rust set colorcolumn=100
let g:rustfmt_autosave = 1

" Force Jenkinsfile to use Groovy syntax
au BufReadPost Jenkinsfile set syntax=groovy

" Black likes 88
au Filetype python set colorcolumn=88

" Haskell
au Filetype haskell set tabstop=2 shiftwidth=2

" JSON
au Filetype json set tabstop=2 shiftwidth=2

" Automatically run black when saving Python files
autocmd BufWritePre *.py execute ':Black'

au Filetype terraform set tabstop=2 shiftwidth=2

" ====================
" === Key Bindings ===
" ====================

nmap <C-n> :NERDTreeToggle<CR>

" This makes shift-tab go back one tab
" for command mode
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>

nnoremap ; :

" Ctrl+c and Ctrl+j as Esc
" Ctrl-j is a little awkward unfortunately:
" https://github.com/neovim/neovim/issues/5916
" So we also map Ctrl+k
inoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <Esc>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

nnoremap <C-c> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
snoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
cnoremap <C-c> <Esc>
onoremap <C-c> <Esc>
lnoremap <C-c> <Esc>
tnoremap <C-c> <Esc>

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

