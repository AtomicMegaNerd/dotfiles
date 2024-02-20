--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Neovim Configuration File

require("amn.plugins")
require("amn.options")
require("amn.autocmds")
require("amn.keymap")
require("amn.lsp")

-- Mac Specific configuration
if vim.fn.has("macunix") == 1 then
	vim.notify("MacOS detected", vim.log.levels.DEBUG)
	require("amn.macos")
end

-- Linux Specific configuration
if vim.fn.has("linux") == 1 then
	vim.notify("Linux detected", vim.log.levels.DEBUG)
	require("amn.linux")
end

vim.notify("Non-Nix installation detected. Using non-nix configuration.", vim.log.levels.DEBUG)
