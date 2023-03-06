--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Neovim Configuration File

require("amn.options")
require("amn.autocmds")
require("amn.keymap")

local install_type = os.getenv("AMN_INSTALL_TYPE")
if install_type ~= nil and install_type == "non-nix" then
	require("amn.plugins")
end

-- Mac Specific configuration
if vim.fn.has("macunix") == 1 then
	require("amn.macos")
end

-- Linux Specific configuration
if vim.fn.has("linux") == 1 then
	require("amn.linux")
end
