"     ___   __                  _      __  ___                 _   __              __
"    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
"   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
"  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
" /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
"                                              /____/
" NeoVim Configuration File

set encoding=utf-8
set termguicolors
set guicursor=a:blinkon100
set mouse=a
set hidden
set nowrap
set smartcase
set shell=/bin/bash
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

set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set nospell

filetype plugin on
filetype indent on

" File Types
" ------------------------------------------------------------------------

" This disables folding for the markdown plug-in.
let g:vim_markdown_folding_disabled = 1

" Rust
au Filetype rust set colorcolumn=100
let g:rustfmt_autosave = 1

" Python 
au Filetype python set colorcolumn=88
autocmd BufWritePre *.py execute ':Black'

" Haskell
au Filetype haskell set tabstop=2 shiftwidth=2

" JSON
au Filetype json set tabstop=2 shiftwidth=2

" Imports
" ------------------------------------------------------------------------
runtime ./plug.vim
runtime ./maps.vim

if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif

" Syntax Theme
" ------------------------------------------------------------------------
colorscheme gruvbox

