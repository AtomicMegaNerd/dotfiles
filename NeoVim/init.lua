--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
-- NeoVim Configuration File

-- Imports of the additional modules
require("custom_funcs")
require("packer_conf")
require("telescope_conf")
require("treesitter_conf")
require("lsp_conf")
require("cmp_conf")
require("keymap")
require("lualine_conf")
require("gitsigns_conf")
require("formatter_conf")
require("lint_conf")
require("autocmds_conf")

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
require("nightfox").load("nightfox")

--Markdown folding
vim.g.vim_markdown_folding_disabled = 1

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_char_highlight = "LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Black
vim.g.black_skip_magic_trailing_comma = 1

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
