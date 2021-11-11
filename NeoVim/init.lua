--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
-- NeoVim Configuration File

-- Imports of the additional modules
require('packer_conf')
require('telescope_conf')
require('treesitter_conf')
require('lsp_conf')
require('cmp_conf')
require('keymap')

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default, then make them relative
vim.wo.number = true
vim.o.relativenumber = true

--Enable mouse mode
vim.o.mouse = 'a'

--Set color column
vim.o.colorcolumn = '100'

--Blinking block cursor!
vim.o.guicursor='a:blinkon100'

--Set tabstop
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

--Clipboard for MacOS
vim.o.clipboard = 'unnamedplus'

--Enable break indent
vim.o.breakindent = true
vim.g.vim_markdown_folding_disabled = 1

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox]]
vim.g.gruvbox_contrast_dark = 'hard'

--Set statusbar
vim.g.lightline = {
  active = { 
    left = {
        { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' }
    }
  },
  component_function = { gitbranch = 'fugitive#head' },
}

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitGutterAdd', text = '+' },
    change = { hl = 'GitGutterChange', text = '~' },
    delete = { hl = 'GitGutterDelete', text = '_' },
    topdelete = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  },
}

-- Highlight on yank
vim.api.nvim_exec(
[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Specific options for different kinds of files
vim.api.nvim_exec([[
  augroup FileTypeOptions
    autocmd!
    autocmd Filetype haskell set tabstop=2 shiftwidth=2
    autocmd Filetype lua set tabstop=2 shiftwidth=2
    autocmd Filetype python set colorcolumn=88
  augroup end
]], false)

-- Show the inlay hints for rust files
vim.api.nvim_exec([[
  augroup ShowInlayHints
    autocmd!
    autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ enabled={"ChainingHint","TypeHint"}, only_current_line = true }
  augroup end
]], false)

-- Format Python files with Black, LSP doesn't support this yet.
vim.api.nvim_exec([[
  augroup FormatWithBlack
    autocmd!
    autocmd BufWritePre *.py execute ':Black'
  augroup end
]], false)

function goimports(timeout_ms)
    local context = { only = { "source.organizeImports" } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end

-- Run Go-autoimporter
vim.api.nvim_exec([[
  augroup RunGoImport
    autocmd!
    autocmd BufWritePre *.go lua goimports(1000) 
  augroup end
]], false)
