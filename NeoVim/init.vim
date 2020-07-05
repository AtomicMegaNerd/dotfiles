" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-easy-align'

Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'itchyny/lightline.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree'

Plug 'chriskempson/base16-vim'

Plug 'psf/black', { 'branch': 'stable' }

" Syntax highlighting
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'


" Initialize plugin system
call plug#end()

" Configure base16 color plug-in
set termguicolors
let base16colorspace=256
colorscheme base16-bright

" Configure cursor
set guicursor=a:blinkon100

" Turn on the gutter
set number

" Automatically run black when saving Python files
autocmd BufWritePre *.py execute ':Black'

" ====================
" === Key Bindings ===
" ====================

nmap <C-n> :NERDTreeToggle<CR>
