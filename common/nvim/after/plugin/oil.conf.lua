local status, oil = pcall(require, "oil")
if not status then
	vim.notify("Cannot load oil.nvim", vim.log.levels.ERROR)
	return
end

oil.setup()
