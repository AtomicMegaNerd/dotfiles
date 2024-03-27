--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--

local o = vim.o
local opt = vim.opt
local wo = vim.wo

-- Set highlight on search
o.hlsearch = false

-- Make line numbers default, then make them relative, also set column
o.relativenumber = true
o.colorcolumn = "100"
wo.number = true
wo.signcolumn = "yes"

o.scrolloff = 8

-- Enable mouse mode
o.mouse = "a"

-- Blinking block cursor!
o.guicursor = "a:blinkon100"

-- Set tabstop
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4

-- Indentation
o.autoindent = true
o.breakindent = true
o.laststatus = 3

-- Save undo history
opt.clipboard:append({ "unnamed", "unnamedplus" })
opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Better completion experience
o.completeopt = "menuone,noselect"

-- Enable spell checking
o.spell = true

