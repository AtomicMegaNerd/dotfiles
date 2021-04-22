set shell=/bin/bash
set encoding=utf-8
set guicursor=a:blinkon100
set colorcolumn=100
set mouse=a
set hidden
set nowrap
set smartcase
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
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set noshowmode
set termguicolors

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
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Syntax highlighting
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Initialize plugin system
call plug#end()

" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Configure base16 color plug-in
let base16colorspace=256
colorscheme base16-default-dark

filetype plugin indent on

" This disables folding for the markdown plug-in.
let g:vim_markdown_folding_disabled = 1

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

