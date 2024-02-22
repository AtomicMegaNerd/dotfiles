--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Custom Neovim keybindings

local utils = require("amn.utils")

-- Arrow keys
----------------------------------------------------------------
-- Disable arrow keys for editing
utils.nmap("<up>", "<nop>")
utils.nmap("<down>", "<nop>")
utils.imap("<up>", "<nop>")
utils.imap("<down>", "<nop>")
utils.imap("<left>", "<nop>")
utils.imap("<right>", "<nop>")

-- Remap ; to : for normal mode
utils.nmap(";", ":")

-- Left and right can switch buffers
utils.nmap("<left>", "<cmd>bp<cr>")
utils.nmap("<right>", "<cmd>bn<cr>")

-- Delete without overwriting the clipboard
utils.nmap("x", '"_x')
