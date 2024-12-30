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
vim.o.relativenumber = true
vim.o.colorcolumn = "100"
vim.wo.number = true
-- Set the sign column to always be visible
vim.wo.signcolumn = "yes"

-- Scroll offset means the cursor will be x lines away from the top/bottom of the screen after
-- scrolling
vim.o.scrolloff = 10

-- Disable mouse support
vim.o.mouse = ""

-- Blinking block cursor!
vim.o.guicursor = "a:blinkon100"

vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.shiftwidth = 4 -- Number of spaces to (auto)indent

-- Indentation
vim.o.autoindent = true
vim.o.breakindent = true

-- Status line always visible and global
vim.o.laststatus = 3

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.smartcase = true

-- Better completion experience
vim.o.completeopt = "menuone,noselect,popup,noinsert"

-- Enable spell checking
vim.o.spell = true

-- Nerd font
vim.g.have_nerd_font = true

-- Do not show the mode because it is already in the status line
vim.opt.showmode = false
-- Highlight the current line
vim.opt.cursorline = true

-- Clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
