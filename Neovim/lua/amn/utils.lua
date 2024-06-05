local M = {}

local do_map = function(mode, keys, func, desc, plugin, bufnr)
	desc = desc or nil
	plugin = plugin or nil
	bufnr = bufnr or nil

	if plugin then
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

M.nmap = function(keys, func, desc, plugin, bufnr)
	desc = desc or nil
	plugin = plugin or nil
	bufnr = bufnr or nil

	return do_map("n", keys, func, desc, plugin, bufnr)
end

M.vmap = function(keys, func, desc, plugin, bufnr)
	desc = desc or nil
	plugin = plugin or nil
	bufnr = bufnr or nil

	return do_map("v", keys, func, desc, plugin, bufnr)
end

M.imap = function(keys, func, desc, plugin, bufnr)
	desc = desc or nil
	plugin = plugin or nil
	bufnr = bufnr or nil
	return do_map("i", keys, func, desc, plugin, bufnr)
end

-- This function is used to import modules in a safe way. It will log an error if the module is
-- not found. The function returns the module if it was found, otherwise it returns nil
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
