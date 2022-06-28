--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default, then make them relative, also set column
vim.wo.number = true
vim.o.relativenumber = true
vim.o.colorcolumn = "100"
vim.wo.signcolumn = "yes"

vim.o.scrolloff = 8

-- Enable mouse mode
vim.o.mouse = "a"

-- Blinking block cursor!
vim.o.guicursor = "a:blinkon100"

-- Set tabstop
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Indentation
vim.o.autoindent = true
vim.o.breakindent = true
vim.o.laststatus = 3

-- Use system clipboard
vim.o.clipboard = "unnamedplus"

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable spellcheck
vim.o.spell = true

-- Better completion experience
vim.o.completeopt = { "menuone,noselect" }

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd("colorscheme nightfox")

-- Vim Rooter
----------------------------------------------------------------
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

-- Use filetypes.lua and disable filetypes.vim
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
