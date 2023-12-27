--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Neovim Configuration File

local install_type = os.getenv("AMN_INSTALL_TYPE")
local non_nix = install_type ~= nil and install_type == "non-nix"

if non_nix then
  require("amn.plugins")
end

require("amn.options")
require("amn.autocmds")
require("amn.keymap")

-- Mac Specific configuration
if vim.fn.has("macunix") == 1 then
  vim.notify("Detected MacOS", vim.log.levels.DEBUG)
  require("amn.macos")
end

-- Linux Specific configuration
if vim.fn.has("linux") == 1 then
  vim.notify("Detected Linux", vim.log.levels.DEBUG)
  require("amn.linux")
end

-- Windows Specific configuration
if vim.fn.has("win32") == 1 then
  vim.notify("Detected Windows", vim.log.levels.DEBUG)
  require("amn.windows")
end

if non_nix then
  vim.notify("Detected Non-Nix Install", vim.log.levels.DEBUG)
end
