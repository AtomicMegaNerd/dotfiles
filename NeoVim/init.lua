--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Neovim Configuration File
local has = vim.fn.has
local is_mac = has("macunix")
local is_win = has("win32")

require("plugins")
require("options")
require("autocmds")
require("keymap")

-- Mac Specific configuration
if is_mac then
	require("macos")
end

-- Windows Specific configuration
if is_win then
	require("windows")
end
