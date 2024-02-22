local M = {}

local do_map = function(mode, keys, func, desc, plugin, bufnr)
	desc = desc or ""
	plugin = plugin or ""
	bufnr = bufnr or nil

	if plugin then
		desc = plugin .. ": " .. desc
	end

	if desc and bufnr then
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
	elseif desc then
		vim.keymap.set(mode, keys, func, { desc = desc })
	elseif bufnr then
		vim.keymap.set(mode, keys, func, { buffer = bufnr })
	else
		vim.keymap.set(mode, keys, func)
	end
end

M.nmap_buf = function(keys, func, desc, plugin, bufnr)
	return do_map("n", keys, func, desc, plugin, bufnr)
end

M.nmap = function(keys, func, desc, plugin)
	return do_map("n", keys, func, desc, plugin, nil)
end

M.imap = function(keys, func, desc, plugin)
	return do_map("i", keys, func, desc, plugin, nil)
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
