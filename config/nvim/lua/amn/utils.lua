local M = {}

-- do_map is a helper function that is used to map keys to functions. It is used by the nmap, vmap,
-- nvmap, and imap functions. It takes the following arguments:
-- mode: The mode to map the keys to. This can be "n", "v", "i", etc.
-- keys: The keys to map. This can be a string or a table of strings.
-- func: The function to call when the keys are pressed.
-- desc: A description of the mapping. This is optional.
-- plugin: The name of the plugin that the mapping is for. This is optional.
-- bufnr: The buffer number to map the keys in. This is optional.
local do_map = function(mode, keys, func, desc, plugin, bufnr)
	if plugin and desc then
		desc = plugin .. ": " .. desc
	end
	local options = {}
	if desc then
		options.desc = desc
	end
	if bufnr then
		options.buffer = bufnr
	end

	vim.keymap.set(mode, keys, func, options)
end

-- The following functions are used to map keys to functions. They are wrappers around the do_map
-- function that set the mode to "n", "v", "i", etc. They take the following arguments:
-- keys: The keys to map. This can be a string or a table of strings.
-- func: The function to call when the keys are pressed.
-- desc: A description of the mapping. This is optional.
-- plugin: The name of the plugin that the mapping is for. This is optional.
-- bufnr: The buffer number to map the keys in. This is optional.

-- The nmap function is used to map keys in normal mode.
M.nmap = function(keys, func, desc, plugin, bufnr)
	do_map("n", keys, func, desc, plugin, bufnr)
end

-- The vmap function is used to map keys in visual mode.
M.vmap = function(keys, func, desc, plugin, bufnr)
	do_map("v", keys, func, desc, plugin, bufnr)
end

-- The nvmap function is used to map keys in normal and visual mode.
M.nvmap = function(keys, func, desc, plugin, bufnr)
	do_map({ "n", "v" }, keys, func, desc, plugin, bufnr)
end

-- The imap function is used to map keys in insert mode.
M.imap = function(keys, func, desc, plugin, bufnr)
	do_map("i", keys, func, desc, plugin, bufnr)
end

-- This function is used to import modules in a safe way. It will log an error if the module is
-- not found. The function returns the module if it was found.
-- module: The name of the module to import.
M.do_import = function(module)
	local status, lib = pcall(require, module)
	if status then
		return lib
	else
		vim.notify("Error importing " .. module, vim.log.levels.ERROR)
		return nil
	end
end

return M
