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
set shell=/usr/local/bin/fish
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

set nosmartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

set clipboard+=unnamedplus

" spelunker is taking care of our spelling needs
set nospell

" Settings for indentation
filetype plugin on
filetype indent on

call plug#begin('~/.config/nvim/plugged')

" Helpers
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-rooter'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'kamykn/spelunker.vim'
Plug 'kamykn/popup-menu.nvim'
Plug 'godlygeek/tabular'
Plug 'dag/vim-fish'
Plug 'preservim/nerdcommenter'

" GUI
Plug 'itchyny/lightline.vim'

" coc and plug-ins
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Theming
Plug 'gruvbox-community/gruvbox'

" Code formatting
Plug 'psf/black', { 'tag': '21.6b0' }
Plug 'sdiehl/vim-ormolu'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue', 'yaml', 'html', 'xml'] }

" Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat'}
Plug 'plasticboy/vim-markdown'
Plug 'hashivim/vim-terraform'
Plug 'neovimhaskell/haskell-vim'

" Initialize plugin system
call plug#end()

" googla-java-format
call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar /Users/chris.dunphy/Tools/google-java-format/google-java-format-1.10.0-all-deps.jar"

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

" Use autocmd to force lightline update
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Configure tree-sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = {"python"}
  }
}
EOF

lua <<EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
require('telescope').load_extension('coc')
require('telescope').load_extension('fzf')
EOF

" This disables folding for the markdown plug-in.
let g:vim_markdown_folding_disabled = 1

" Going with gruvbox for now
colorscheme gruvbox

" Rust
au Filetype rust set colorcolumn=100
let g:rustfmt_autosave = 1

let g:terraform_fmt_on_save=1
let g:terraform_align=1

" Force Jenkinsfile to use Groovy syntax
au BufReadPost Jenkinsfile set syntax=groovy

" Black likes 88
au Filetype python set colorcolumn=88

" Haskell
au Filetype haskell set tabstop=2 shiftwidth=2

" JSON
au Filetype json set tabstop=2 shiftwidth=2

" Java
au FileType java set tabstop=4 shiftwidth=4

" Automatically run black when saving Python files
autocmd BufWritePre *.py execute ':Black'
autocmd FileType java AutoFormatBuffer google-java-format

au Filetype terraform set tabstop=2 shiftwidth=2

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" ====================
" === Key Bindings ===
" ====================

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

" Use <c-space> to trigger completion.
inoremap <silent><expr> <C-space> coc#refresh()

" GoTo code navigation.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

" Open my nvim configuration
nmap <leader>vc :e $MYVIMRC<cr>

" Telescope key bindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>ft <cmd>Telescope git_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
