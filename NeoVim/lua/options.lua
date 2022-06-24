--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default, then make them relative
vim.wo.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8

--Enable mouse mode
vim.o.mouse = "a"

--Set color column
vim.o.colorcolumn = "100"

--Blinking block cursor!
vim.o.guicursor = "a:blinkon100"

--Set tabstop
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Indentation
vim.o.autoindent = true
vim.o.breakindent = true
vim.o.laststatus = 3

--Use system clipboard
vim.o.clipboard = "unnamedplus"

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 300
vim.wo.signcolumn = "yes"

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd("colorscheme nightfox")

--Markdown folding
vim.g.vim_markdown_folding_disabled = 1

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_char_highlight = "LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent = false

--Vim Rooter
-- These files signify the root of a project.
vim.g.rooter_patterns = {
	"Makefile",
	"Cargo.toml",
	"Pipfile",
	"*.mod",
	"Dockerfile",
	"VERSION",
	"CHANGELOG.md",
	"*.cabal",
	"stack.yaml",
	"init.lua",
	"config.fish",
}

vim.cmd("filetype plugin indent on")
